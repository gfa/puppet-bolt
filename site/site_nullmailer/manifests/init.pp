# this class wraps the nullmailer module to call apt update before trying to install nullmailer
# only really matters on the first puppet run, when sources.list gets changed
#
# depends on the nullmailer and apt modules

class site_nullmailer {

  class { 'nullmailer':
    require => Exec['apt_update'],
  }

  # install the wrapper to make smtp auth happy (forces the "From:" field)
  # see https://github.com/bruceg/nullmailer/issues/72

  exec { 'divert sendmail':
    command => 'dpkg-divert --divert /usr/sbin/sendmail-bin --rename /usr/sbin/sendmail',
    creates => '/usr/sbin/sendmail-bin',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  file { '/usr/sbin/sendmail':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['divert sendmail'],
    content => epp("${module_name}/usr/sbin/sendmail.epp"),
  }

}
