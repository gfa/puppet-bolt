Puppet Bolt repo to manage my servers
=====================================

This repo does not follow the [role and profile method](https://puppet.com/docs/pe/2018.1/the_roles_and_profiles_method.html).

It only manages the base configuration common to
all my servers, which is

- apt repos
- unattended upgrades
- munin agent
- fail2ban
- logcheck
- ntp
- some basic packages
- nullmailer
- sshd
- root user account
- a hidden sshd service (tor)

Higher level applications (postfix, nginx, etc) are not managed by puppet ATM.
I don't have that many servers.

I try to have as little as possible code outside modules and as much as possible configured by hiera.

Modules
-------

Modules are managed by bolt itself, they are declared on the `Puppetfile`.
The extra modules are required to run bolt.

```shell
bolt puppetfile install
```

Hiera
-----

Hiera is kept in a private repo. Hiera is data not code, so I won't share it.

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
mkdir .gem
export GEM_HOME=$PWD/.gem
export GEM_PATH=$PWD/.gem
export PATH=“$GEM_HOME/bin:$PATH”
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

Docker
------

This repo contains a `Dockerfile` to build a container with this code including hiera.


AWS ECS 
-------

<warning> proprietary software ahead.</warning>

I want to routinely apply this code to my servers, there are ~~2~~ many ways to do that


- Puppet master
  One more service to maintain :( .

- Run `bolt` with a cronjob on a fix machine
  It could have a SSH Key (~/.ssh/id_rsa) or a [security](https://www.nitrokey.com/) [token](https://www.yubico.com/)
  but both cases open a window to someone to break into that machine and get the kingdom's keys.

- Run `bolt` from a container
  This is similar than the previous idea with the improvement that containers are short-lived, so
  "harder" to break in.

- Run https://github.com/jethrocarr/pupistry
  This option actually looks pretty good. I'd use it if I wouldn't want to play with KMS.

- Run `bolt` from a container with an ephemeral ssh key
  Using a CA that generates short-lived SSH keys, an idea stolen from [bless](https://github.com/Netflix/bless).

  [cashier](https://github.com/nsheridan/cashier) looks simpler to deploy, but both options are just too much
  for single user infrastructure.


- Run `bolt` from a container, retrieve the ssh key within the container
  I could do this, storing the key in KMS/Barbican, If means that you completely trust your provider,
  while in reality you *do* completely trust your provider, I prefer acting like I don't.
  Also feels a bit lazy.

- Run `bolt` from a container, retrieve the ssh key *password* within the container
  Similar to the previous case but instead of giving the key to my provider, I give the key's password
  to my provider while keeping the key someplace else.
