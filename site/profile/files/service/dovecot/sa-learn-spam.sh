#!/bin/bash

mkdir -p /srv/vmail/antispam/${1}/spam
TEMP=$(mktemp -p /srv/vmail/antispam/${1}/spam)
cat - > $TEMP

/usr/bin/maddr -a -h 'from:sender:reply-to' $TEMP >> $HOME/spam.txt 2>>/tmp/maddr.log

MAX_SIZE=$(grep max-size /etc/spamassassin/spamc.conf | awk '{print $2}')
MAIL_SIZE=$(stat --printf=%s $TEMP)

if [ $MAIL_SIZE -gt $MAX_SIZE ]; then
	rm -f $TEMP
	exit 0
fi

# TODO: move this to an async process, like before
# per user white and blacklist can be saved  ~/.spamassassin/user_prefs

nohup /usr/bin/spamc -u ${1} -L spam < $TEMP &
nohup /usr/bin/spamc -u ${1} -C report < $TEMP &

env > /tmp/spam-env.txt
echo $TEMP >> /tmp/spam-env.txt
exit 0
