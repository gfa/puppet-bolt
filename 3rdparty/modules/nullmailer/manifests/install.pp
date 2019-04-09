# === Copyright
#
# Copyright Dennis Philpot
#
class nullmailer::install (
  $package_ensure = $::nullmailer::package_ensure,
  $package_name = $::nullmailer::package_name,
) {
  package { 'nullmailer':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
