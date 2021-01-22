# this class provides the list of installed packages as a custom fact
# inspired on git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
# cead6de02810f62af1f679363843bb3444f11425
# bugs are mine

class site_facts::installed_packages {

  file { '/var/lib/misc/thishost':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/etc/apt/apt.conf.d/local-pkglist':
    ensure => absent,
  }

}
