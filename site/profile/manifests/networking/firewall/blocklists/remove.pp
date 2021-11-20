# this class removes any trace of blocklists
#
#
class profile::networking::firewall::blocklists::remove {

  require profile::networking::firewall::base

  file { '/etc/cron.hourly/update-ipsets-blocklists':
    ensure => absent,
  }

  file { '/usr/local/bin/update-ipsets-blocklists':
    ensure  => absent,
  }

  file { '/etc/cron.daily/update-countries-ipset':
    ensure  => absent,
  }

  file { '/usr/local/bin/update-countries-ipset':
    ensure  => absent,
  }

  file { '/etc/cron.d/update-ipsets':
    ensure  => absent,
  }

}
