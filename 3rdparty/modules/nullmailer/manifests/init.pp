# === Copyright
#
# Copyright Dennis Philpot
#
class nullmailer (
  Array[String] $remotes,
  String $adminaddr = '',
  String $defaultdomain = $::domain,
  Optional[String] $me = undef,
  Optional[String] $package_ensure = undef,
  String $package_name  = 'nullmailer',
) {
  contain ::nullmailer::install
  contain ::nullmailer::config
  contain ::nullmailer::service

  Class['nullmailer::install'] -> Class['nullmailer::config'] ~> Class['nullmailer::service']
}
