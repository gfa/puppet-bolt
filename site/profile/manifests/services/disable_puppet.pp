# This class disables the puppet agent
#

class profile::services::disable_puppet {

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

}
