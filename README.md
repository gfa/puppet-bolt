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

Setup
-----

~~~~
git clone `this repo`

cd `this repo`
git clone `hiera repo` hieradata
ln -s hieradata/inventory.yaml .
ln -s hieradata/keys .
mkdir logs

mkdir .gem
export GEM_HOME=$PWD/.gem
export GEM_PATH=$PWD/.gem
export PATH="$GEM_HOME/bin:$PATH"
gem install bundler
bundler install
bolt puppetfile install
~~~

Install Puppet on all nodes
---------------------------

~~~
bolt task run puppet_agent::install  -n all
~~~


TODO
----

- on buster hosts, choose iptables-legacy
- nginx
- dehydrated
- postfix
- spamassassin
- radicale
- tor
- prosody to syslog
- radicale to syslog

Links
-----

- https://github.com/puppetlabs/tasks-playground

Run puppet like puppet apply/puppet agent
-----------------------------------------

Run noop using bolt apply (does not include includes and so on)

~~~
bolt apply --noop --verbose site/base/manifests/init.pp -n all
~~~

Run the default plan
~~~
bolt plan run base -n all 
~~~
