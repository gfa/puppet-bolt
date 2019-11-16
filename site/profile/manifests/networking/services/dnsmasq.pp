# this class manages dnsmasq
#
# @param configs_hash contains dnsmasq's config

class profile::networking::services::dnsmasq (
  Hash $configs_hash,
) {

  class { 'dnsmasq':
    purge_config_dir => true,
    configs_hash     => $configs_hash,
  }

  file { '/etc/cron.hourly/update-ipsets':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/update-ipsets",
  }

}
