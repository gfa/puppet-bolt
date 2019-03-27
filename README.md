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

How to install bolt
-------------------

~~~~
git clone `this repo`

cd `this repo`

mkdir .gem
export GEM_HOME=$PWD/.gem
export GEM_PATH=$PWD/.gem
export PATH="$GEM_HOME/bin:$PATH"
gem install bundler
bundler install
bolt puppetfile install
~~~

Things to do
------------


- send nginx error logs to syslog
- send tor to syslog
- prosody to syslog
- radicale to syslog


bolt plan run base -n db.zumbi.com.ar
