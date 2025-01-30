# this class manages tunnels towards places
#
# @param tunnels
#
class site_tunnels (
  Array[Hash] $tunnels,
  Boolean $enabled = false,
) {

  if $enabled {

    group { 'tunnels': }

    user { 'tunnels':
      managehome     => true,
      gid            => 'tunnels',
      purge_ssh_keys => true,
      home           => '/etc/tunnels',
    }

    file { ['/etc/tunnels/.ssh', '/etc/tunnels']:
      ensure  => directory,
      mode    => '0700',
      owner   => 'tunnels',
      recurse => true,
      purge   => true,
    }

    $tunnels.each | Hash $data | {

      file { "/etc/tunnels/.ssh/id_${data['name']}":
        ensure  => file,
        mode    => '0400',
        owner   => 'tunnels',
        content => Sensitive($data['private_key']),
      }

      systemd::unit_file { "${data['name']}.service":
        ensure  => absent,
      }

      systemd::unit_file { "${data['name']}-tunnel.service":
        ensure  => present,
        enable  => true,
        content =>  template("${module_name}/etc/systemd/system/tunnel.service.erb"),
      }

      service { "${data['name']}-tunnel":
        ensure => running,
        enable => true,
      }

      if lookup('manage_iptables', Boolean, undef, true) {
        firewall_multi { "300 allow outgoing tunnel to ${data['name']}":
          chain       => 'OUTPUT',
          dport       => 9022,
          action      => 'accept',
          destination => $data['remote'],
        }
      }

    }
  } else {

    file { '/etc/tunnels/':
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }
}
