# manages some bits around etckeeper
#

class profile::package::etckeeper {

  file_line { 'Append a line to /etc/.gitignore':
    path    => '/etc/.gitignore',
    line    => "puppet/*\n",
    match   => '^puppet\/\*$',
    require => Package['etckeeper'],
  }

  $files = [
    '/usr/local/bin/puppet-etckeeper-commit-pre',
    '/usr/local/bin/puppet-etckeeper-commit-post',
  ]

  $files.each | $file | {

    file { $file:
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/${module_name}${file}",
    }
  }

  ini_setting { 'puppet_conf_main_pre_run':
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'main',
    setting => 'prerun_command',
    value   => '/usr/local/bin/puppet-etckeeper-commit-pre',
  }

  ini_setting { 'puppet_conf_main_post_run':
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'main',
    setting => 'postrun_command',
    value   => '/usr/local/bin/puppet-etckeeper-commit-post',
  }

}
