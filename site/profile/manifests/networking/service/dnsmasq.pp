# this class manages dnsmasq
#
# @param configs_hash contains dnsmasq's config
#
class profile::networking::service::dnsmasq (
  Hash $configs_hash,
  Boolean $manage_dnsmasq = true,
) {

  if $manage_dnsmasq {
    class { 'dnsmasq':
      purge_config_dir => true,
      configs_hash     => $configs_hash,
    }

    file { '/etc/cron.hourly/update-ipsets':
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/networking/service/update-ipsets",
      notify => Exec['update_ipsets'],
    }

    exec { 'update_ipsets':
      command     => '/etc/cron.hourly/update-ipsets',
      refreshonly => true,
    }
  }

}
