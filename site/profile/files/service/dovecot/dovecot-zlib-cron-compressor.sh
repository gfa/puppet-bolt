#!/bin/bash
set -fue
# This is implementation of the script that compresses old maildir messages
# as described in http://wiki2.dovecot.org/Plugins/Zlib
#
# Copyright (C) 2016 by Konstantin Ryabitsev
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Configurable parameters
# Toplevel with all the mailboxes
MAILTOP=/srv/vmail

# What should we use to compress the messages
# NOTE: check that your zlib plugin was actually compiled to support that.
# E.g. on RHEL7 there is no support for xz, only gz and bzip2
COMPRESSOR=/usr/bin/xz

# Level of compression to use (6 is the default).
LEVEL=6

# Compress messages older than this many days. You probably don't want to
# make this too small, as we want to compress mail that's not likely to be
# frequently touched by clients.
OLDERTHANDAYS=90

# Where do we find maildirlock (part of dovecot)
MAILDIRLOCK=/usr/lib/dovecot/maildirlock

# How long should we wait for the lock before moving on (seconds)
LOCKTIMEOUT=5

# List any directories under MAILTOP that you want to exclude
EXCLUDEUSERS=""

# This should have "cur" if you only want to compress non-new mail, or "cur new"
# for everything.
INCLUDEFOLDERS="cur new"

# End configurable parameters

# Script begins here
TMPFILELIST=$(mktemp --suffix='MAILCOMPRESSOR')

# First, find all toplevel mailboxes
find $MAILTOP -maxdepth 1 -mindepth 1 -type d -print0 | while read -d $'\0' USERDIR; do
	EXCLUDED=0
	for EXCLUDEUSER in $EXCLUDEUSERS; do
		if [ "${USERDIR}" == "${MAILTOP}/${EXCLUDEUSER}" ]; then
			EXCLUDED=1
			break
		fi
	done
	if [ "${EXCLUDED}" == "1" ]; then
		continue
	fi

	# Now find all dirs we want
	for INCLUDEFOLDER in $INCLUDEFOLDERS; do

		find "${USERDIR}" -type d -a -name "${INCLUDEFOLDER}" -print0 2>/dev/null | while read -d $'\0' FOLDER; do
			MAILFOLDER=$(dirname "${FOLDER}")
			TMPFOLDER="${MAILFOLDER}/tmp"
			# If tmpdir does not exist, something is odd
			if [ ! -d "${TMPFOLDER}" ]; then
				continue
			fi

			# Now find any old files that haven't been compressed yet
			# We store it in a temporary file so we avoid locking a maildir if the list is empty
			find "${FOLDER}" -iname '*,S=*[^Z]' -size +2048c -mtime +${OLDERTHANDAYS} -print0 >$TMPFILELIST
			if [ -s "${TMPFILELIST}" ]; then
				# Compress first
				cat $TMPFILELIST | while read -d $'\0' EMAILFILE; do
					# Is it still there?
					if [ -f "${EMAILFILE}" ]; then
						# Get the tmp location for this file
						BASEFILE=$(basename "${EMAILFILE}")
						TMPFILE="${TMPFOLDER}/${BASEFILE}"
						# Has it been compressed already?
						rm -f "${TMPFILE}"
						if ! /usr/bin/file $EMAILFILE | grep -q 'compressed data'; then
							# Compress it into TMPFILE
							${COMPRESSOR} -${LEVEL} -c "${EMAILFILE}" >"${TMPFILE}"
						else
							# What happened? Why does it not end with Z? Bad previous run?
							# Just copy it over then
							cp "${EMAILFILE}" "${TMPFILE}"
						fi
						# Set the same mtime
						touch -r "${EMAILFILE}" "${TMPFILE}"
						# Set the same modes
						chmod --reference "${EMAILFILE}" "${TMPFILE}"
					fi
				done
				# Now we lock maildir and move all these files to replace old ones
				if [ ! -f "${MAILFOLDER}/dovecot-uidlist.lock" ]; then
					touch "${MAILFOLDER}/dovecot-uidlist.lock"
					# Iterate through the list again
					cat $TMPFILELIST | while read -d $'\0' EMAILFILE; do
						BASEFILE=$(basename "${EMAILFILE}")
						TMPFILE="${TMPFOLDER}/${BASEFILE}"
						if [ -f "${TMPFILE}" -a -f "${EMAILFILE}" ]; then
							mv -f "${TMPFILE}" "${EMAILFILE}"
							mv -f "${EMAILFILE}" "${EMAILFILE}Z"
						fi
					done

					# Free up the maildir
					rm -f "${MAILFOLDER}/dovecot-uidlist.lock"
				else
					# Could not lock maildir, so I guess just clean up
					cat $TMPFILELIST | while read -d $'\0' EMAILFILE; do
						BASEFILE=$(basename "${EMAILFILE}")
						TMPFILE="${TMPFOLDER}/${BASEFILE}"
						rm -f "${TMPFILE}"
					done
				fi
			fi
		done
	done
done

rm -f $TMPFILELIST
