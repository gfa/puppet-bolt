#!/bin/bash

mkdir -p /srv/vmail/antispam/${1}/ham
TEMP=$(mktemp -p /srv/vmail/antispam/${1}/ham)
cat - > $TEMP

/usr/bin/maddr -a -h 'from:sender:reply-to' $TEMP >> $HOME/ham.txt 2>>/tmp/maddr.log
exit 0

MAX_SIZE=$(grep max-size /etc/spamassassin/spamc.conf | awk '{print $2}')
MAIL_SIZE=$(stat --printf=%s $TEMP)

if [ $MAIL_SIZE -gt $MAX_SIZE ]; then
	rm -f $TEMP
	exit 0
fi

nohup /usr/bin/spamc -u ${1} -L ham < $TEMP &
nohup /usr/bin/spamc -u ${1} -C revoke < $TEMP &

env > /tmp/ham-env.txt
echo $TEMP >> /tmp/ham-env.txt
#rm -f $TEMP
exit 0
