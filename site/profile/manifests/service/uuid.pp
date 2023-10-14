# this class manages the uuid.[service|socket]
#
class profile::service::uuid {

  service { 'uuidd.socket':
    ensure => stopped,
    enable => false,
  }
}
