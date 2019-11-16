# this class manages dehydrated
#
# @param domains contains a hash of domains (keys) and their SANs (array with values) to requests certificates for
#

class site_dehydrated (
  Hash[String, Variant[Array, Undef]] $domains,
) {

  include profile::nginx::dehydrated

  package { 'dehydrated':
    ensure => latest,
  }

  file { '/etc/dehydrated/hooks':
    ensure => directory,
  }

  file { '/etc/dehydrated/conf.d/hook.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'HOOK="/etc/dehydrated/hook.sh"
    ',
  }

  $hook_contents = "#!/bin/sh
run-parts /etc/dehydrated/hooks\n"

  file { '/etc/dehydrated/hook.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $hook_contents,
  }

  file { '/etc/dehydrated/domains.txt':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/domains.txt.erb"),
    notify  => Exec['run_dehydrated'],
  }

  exec { 'run_dehydrated':
    cwd         => '/',
    command     => '/usr/bin/dehydrated -c',
    refreshonly => true,
    user        => 'root',
  }

  $cron_contents = "#!/bin/sh
set -e
/usr/bin/chronic -e /usr/bin/dehydrated -c\n"

  file { '/etc/cron.weekly/dehydrated':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $cron_contents,
  }

}
