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
    ]:
      ensure => directory,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
  }

}
