# this class manages dnsmasq
#
# @param configs_hash contains dnsmasq's config

class base::dnsmasq (
  Hash $configs_hash,
) {

  package { 'unbound':
    ensure => purged,
  }

  -> class { 'dnsmasq':
    purge_config_dir => true,
    configs_hash     => $configs_hash,
  }

}
