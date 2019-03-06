This repo uses bolt to manage servers
-------------------------------------

Remove `IdentitiesOnly yes` from `~/.ssh/config` as it is not supported
https://tickets.puppetlabs.com/browse/BOLT-81

https://github.com/puppetlabs/bolt/issues/418
https://tickets.puppetlabs.com/browse/BOLT-152
https://tickets.puppetlabs.com/browse/BOLT-495


How to run bolt
---------------

This invocation will run site.pp

`bolt plan run site -n all'

This invocation will run profiles::nginx_install

`bolt plan run profiles::nginx_install -n all`

Docs:
https://puppet.com/blog/introducing-masterless-puppet-bolt

Things to do
------------


- send fail2ban logs to syslog
- send nginx error logs to syslog
- send tor to syslog
- firewall OUTPUT 
- prosody to syslog
- radicale to syslog
- fail2ban from testing
- create a chain FILTERS in iptables
- make fail2ban to use chan FILTERS
- manage firewall
- limit ciphers sshd accepts
