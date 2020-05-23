Puppet Bolt repo to manage my servers
=====================================

At the moment it only manages the base configuration common to
all my servers, which is:

- apt repos
- unattended upgrades
- munin agent
- fail2ban
- logcheck
- ntp
- common packages
- nullmailer
- sshd
- root user account
- a hidden sshd service (tor)
- firewall

Higher level applications (postfix) are not managed by puppet ATM.
I don't have that many servers ¯\_(ツ)_/¯.

Roles
-----

I don't have roles yet, I just include `profiles` from hiera.


3rd party Modules
-----------------

Modules are managed by bolt itself, they are declared on the `Puppetfile`.

```shell
bolt puppetfile install
```

Hiera
-----

Hiera is kept in a private repo. Hiera is data not code, so I keep it private.

hiera-eyaml-gpg doesn't work with multiple [subkeys](https://github.com/voxpupuli/hiera-eyaml-gpg/issues/6) :(

how to protect the eyaml key with password

```shell
openssl rsa -aes256 -in private_key.pkcs7.pem -out private_key.pkcs7.pass.pem
```

Setup
-----

```shell
git clone https://github.com/gfa/puppet-bolt.git
cd puppet-bolt
git clone $HIERA_REPO hieradata
ln -s hieradata/inventory.yaml .
ln -s hieradata/keys .
mkdir logs
gem install bundler
bundler install
bolt puppetfile install
```


Docs
-----

- https://puppet.com/blog/introducing-masterless-puppet-bolt
- https://github.com/puppetlabs/tasks-playground
- Remove `IdentitiesOnly yes` from `~/.ssh/config` as it is not supported

  https://tickets.puppetlabs.com/browse/BOLT-81
- https://github.om/puppetlabs/bolt/issues/418
- https://tickets.puppetlabs.com/browse/BOLT-152
- https://tickets.puppetlabs.com/browse/BOLT-495


Running bolt
------------

Run noop using bolt apply (does not include includes and so on)

```shell
bolt apply --noop --verbose site/base/manifests/init.pp -n all
```

This invocation will run profiles::nginx_install

```shell
bolt plan run profiles::nginx_install -n all
```
This invocation will install puppet on all nodes

```shell
bolt task run puppet_agent::install  -n all
```

This invocation will run site.pp on all servers

```shell
$ bolt plan run base -n all
```

Install puppet (requires libwww-perl to be installed)

```shell
$ bolt task run puppet_agent::install -n  all
```

Scheduled runs of this repo
---------------------------

Currently I'm using GitLab CI to run Puppet.
