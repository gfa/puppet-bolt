# Class: tor
class tor (
  String $package_name = $tor::params::package_name,
  String $package_ensure = $tor::params::package_ensure,

  String $config_dir = $tor::params::config_dir,
  String $instances_config_dir = $tor::params::instances_config_dir,

  Hash $instances = {}
) inherits tor::params {
  contain ::tor::install
  contain ::tor::config

  Class['::tor::install']
  -> Class['::tor::config']

  create_resources('::tor::instance', $instances, { ensure => present })
}
