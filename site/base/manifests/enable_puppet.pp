# This class enables the puppet agent
#

class base::enable_puppet {

  service { 'puppet':
    ensure => running,
    enable => true,
  }

  service { 'mcollective':
    ensure => stopped,
    enable => false,
  }

  package { 'puppet-release':
    ensure => purged,
  }

  package { 'puppet5-release':
    ensure => purged,
  }

  package { 'puppet6-release':
    ensure => purged,
  }

  package { 'puppet-agent':
    ensure => purged,
  }

  package { 'puppetlabs-release-pc1':
    ensure => purged,
  }

  package { 'puppetlabs-release':
    ensure => purged,
  }

}
