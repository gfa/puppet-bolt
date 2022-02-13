# this class manages tunnels towards places
#
class site_tunnels (
  Array[Hash] $tunnels,
) {

  group { 'tunnels': }

  user { 'tunnels':
    managehome     => true,
    gid            => 'tunnels',
    purge_ssh_keys => true,
    home           => '/etc/tunnels',
  }

  file { '/etc/tunnels/.ssh':
    ensure => directory,
    mode   => '0700',
    owner  => 'tunnels',
  }

  $tunnels.each | Hash $data | {

    file { "/etc/tunnels/.ssh/id_${data['name']}":
      ensure  => file,
      mode    => '0400',
      owner   => 'tunnels',
      content => Sensitive($data['private_key']),
    }

    systemd::unit_file { "${data['name']}.service":
      ensure  => present,
      enable  => true,
      content =>  template("${module_name}/etc/systemd/system/tunnel.service.erb"),
    }

    firewall_multi { "300 allow outgoing tunnel to ${data['name']}":
      chain       => 'OUTPUT',
      dport       => 22,
      action      => 'accept',
      destination => "${data['remote']}",
    }

  }
}
