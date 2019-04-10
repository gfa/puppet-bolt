# this class configures a tor instance wich provides
# a hidden ssh service

class site_tor::sshd {

  include tor

  exec { 'tor_sshd_instance':
    command => 'tor-instance-create sshd',
    creates => '/etc/tor/instances/sshd',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  -> tor::instance { 'sshd':
    settings => {
      'HiddenServiceDir'  => '/var/lib/tor-instances/sshd/hidden_service/',
      'HiddenServicePort' => "22 ${facts['ipaddress']}:22",
      'SocksPort'         => '0',
    }
  }

  -> firewall { '300 allow outgoing connections for tor-sshd':
    chain  => 'OUTPUT',
    uid    => '_tor-sshd',
    action => 'accept',
    proto  => 'tcp',
  }

}
