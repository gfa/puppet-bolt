# https://salsa.debian.org/dsa-team/mirror/dsa-puppet/blob/master/modules/munin/manifests/check.pp

# enable (or disable) a munin check
# @param ensure check enabled/disabled
# @param script check to synclink
define site_munin::node::check(
  Enum['present','absent'] $ensure = 'present',
  String $script = $name
) {

  $link_target = $ensure ? {
    'present' => link,
    'absent'  => absent,
  }

  file { "/etc/munin/plugins/${name}":
    ensure  => $link_target,
    target  => "/usr/share/munin/plugins/${script}",
    require => Package['munin-node'],
    notify  => Service['munin-node', 'munin-async'],
  }
}
