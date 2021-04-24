# this class configures apache for dn42

class profile::networking::dn42::apache {

  include apache

  firewall_multi { '300 allow incoming http traffic':
    provider => ['iptables', 'ip6tables'],
    chain    => 'INPUT',
    action   => 'accept',
    proto    => 'tcp',
    port     => '80',
  }

  file { '/var/www/html/4679.ar/index.txt':
    ensure => file,
    mode   => '0644',
    group  => 'root',
    owner  => 'root',
    source => "puppet:///modules/${module_name}/var/www/html/index.txt",
  }

  apache::vhost { '4679.ar':
    port           => 80,
    docroot        => '/var/www/html/4679.ar',
    directoryindex => 'index.html index.txt',
    default_vhost  => true,
    serveraliases  => [
      'dn42.4679.ar',
      'as4242421097.ar',
    ],
  }

}
