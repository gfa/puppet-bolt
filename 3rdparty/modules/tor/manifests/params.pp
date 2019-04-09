# Class: tor::params
class tor::params {
  $package_name = 'tor'
  $package_ensure = 'present'

  $config_dir = '/etc/tor'
  $instances_config_dir = "${config_dir}/instances"
}
