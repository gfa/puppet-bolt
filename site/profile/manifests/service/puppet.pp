# This manages puppet
#
#
class profile::service::puppet {

  service { 'puppet-agent':
    ensure => stopped,
    enable => false,
  }

  service { 'puppet':
    ensure => stopped,
    enable => false,
  }

  service { 'mcollective':
    ensure => stopped,
    enable => false,
  }

  service { 'pxp-agent':
    ensure => stopped,
    enable => false,
  }

  file { [
      '/etc/puppet',
      '/etc/puppet/code',
      '/etc/puppet/code/lib',
      '/etc/puppet/code/site',
      '/etc/puppet/code/hieradata',
      '/etc/facter',
    ]:
      ensure => directory,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
  }

  file { '/etc/facter/facts.d':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    recurse => true,
    purge   => true,
  }

  cron { 'purge-puppet-cache':
    command     => '/usr/bin/find /var/cache/puppet/ -type f -mtime +7 -delete >/dev/null || /usr/bin/true',
    user        => 'root',
    hour        => '23',
    minute      => 10,
    weekday     => 4,
    environment => 'PATH=/bin:/usr/bin:/usr/sbin:/sbin',
  }

}
