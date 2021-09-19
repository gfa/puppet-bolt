# this class configures apt pinning
#
# @param backports Contains packages that should be pinned to -backports
#
class profile::package::pinning (
  Array[String] $backports,
) {

  apt::pin { 'backports':
    packages => $backports,
    priority => 990,
    release  => "${facts['os']['distro']['codename']}-backports",
    require  => Class['apt'],
  }

  apt::pin { 'journalbeat':
    packages => ['journalbeat'],
    priority => 990,
    version  => '7.14.1',
  }

}
