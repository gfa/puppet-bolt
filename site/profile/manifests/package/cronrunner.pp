# deploys my ~awesome~ crappy wrapper for cronjobs
#

class profile::package::cronrunner {

  file { '/usr/local/bin/cronrunner':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/usr/local/bin/cronrunner.py",
  }

}
