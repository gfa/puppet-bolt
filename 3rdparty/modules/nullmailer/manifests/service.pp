# === Copyright
#
# Copyright Dennis Philpot
#
class nullmailer::service {
  service { 'nullmailer':
    ensure => running,
    enable => true,
  }
}
