# this class manages crond

class profile::service::crond {

  include cron

  file { '/etc/crontab':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/etc/crontab.epp"),
  }

}
