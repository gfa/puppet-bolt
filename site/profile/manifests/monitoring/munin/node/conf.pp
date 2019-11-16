# https://salsa.debian.org/dsa-team/mirror/dsa-puppet/blob/master/modules/munin/manifests/conf.pp

# @param ensure check enabled/disabled
# @param content content to put into plugon-conf.d/<name>
# @param source file to put into plugon-conf.d/<name>

# TODO: replace with https://forge.puppet.com/ssm/munin

define profile::monitoring::munin::node::conf (
  Enum['present','absent'] $ensure = 'present',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
) {

  file { "/etc/munin/plugin-conf.d/${name}":
    ensure  => $ensure,
    source  => $source,
    content => $content,
    require => Package['munin-node'],
    notify  => Service['munin-node', 'munin-async'],
  }

}
