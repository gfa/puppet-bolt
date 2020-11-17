# this class manages clamav and friends
#
# @param mirrors list with mirrors where freshclam is allowed to connect to
#

class profile::security::service::clamav (
  Array[String] $mirrors,
) {

  apt::pin { 'clamav':
    packages => ['clamav-daemon', 'clamav-freshclam', 'libclamav9'],
    priority => 990,
    release  => "${facts['os']['distro']['codename']}-backports",
  }

  -> class {'clamav':
    manage_clamd             => true,
    manage_freshclam         => true,
    clamd_service_ensure     => 'running',
    freshclam_service_ensure => 'running',
    clamd_options            => {
      'LogSyslog'          => true,
      'LogFacility'        => 'LOG_LOCAL6',
      'LogClean'           => false,
      'LogVerbose'         => false,
      'CommandReadTimeout' => 30,
    },
    freshclam_options        => {
      'LogSyslog'   => true,
      'LogFacility' => 'LOG_LOCAL6',
    },
  }

  -> profile::networking::service::dnsmasq::ipset { 'clamav':
    ipset_hosts => $mirrors,
  }

  -> firewall { '300 Allow network access to freshclam4':
    chain    => 'OUTPUT',
    dport    => ['80', '443', '873'],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'clamav4 dst',
    uid      => 'clamav',
  }

  -> firewall { '300 Allow network access to freshclam6':
    chain    => 'OUTPUT',
    dport    => ['80', '443', '873'],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'clamav6 dst',
    uid      => 'clamav',
  }

}
