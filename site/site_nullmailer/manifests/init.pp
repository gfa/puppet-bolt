# this class wraps the nullmailer module to call apt update before trying to install nullmailer
# only really matters on the first puppet run, when sources.list gets changed
#
# depends on the nullmailer and apt modules

class site_nullmailer {

  class { 'nullmailer':
    require => Exec['apt_update'],
  }

}
