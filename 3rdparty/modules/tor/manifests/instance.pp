# Defined type: tor::instance
define tor::instance (
  Pattern[/^(present|absent)$/] $ensure = 'present',
  Hash $settings = {},
){
  if !defined(Class['::tor']) {
    fail('You must include the tor class before creating an instance')
  }

  if $ensure == 'present' {
    $config_dir_ensure = 'directory'

    $config_file_ensure = 'file'

    $service_ensure = 'running'
    $service_enable = true
  }
  else {
    # In case $ensure is 'absent', we want to remove the instance directory and
    # stop the associated service

    $config_dir_ensure = 'absent'

    $config_file_ensure = 'absent'

    $service_ensure = 'stopped'
    $service_enable = false
  }

  $service_name = "tor@${name}" # This module only works with systemd

  if $name == 'default' {
    $config_dir = $::tor::config_dir
    $config_file = "${config_dir}/torrc"
    $config_file_owner = 'debian-tor'
    $config_file_group = 'debian-tor'
  }
  else {
    $config_dir = "${::tor::instances_config_dir}/${name}"
    $config_file = "${config_dir}/torrc"
    $config_file_owner = "_tor-${name}"
    $config_file_group = "_tor-${name}"

    ensure_resource('file', $::tor::instances_config_dir, {
      ensure  => directory,
      purge   => true,
      recurse => true,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    })

    file { $config_dir:
      ensure  => $config_dir_ensure,
      purge   => true,
      recurse => true,
      owner   => $config_file_owner,
      group   => $config_file_group,
      mode    => '0750',
    }
  }

  file { $config_file:
    ensure  => $config_file_ensure,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => '0640',
    content => template('tor/torrc.erb'),
    require => File[$config_dir],
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => File[$config_file],
  }
}
