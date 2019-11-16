# this class provides the list of installed packages as a custom fact
# inspired on git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
# cead6de02810f62af1f679363843bb3444f11425
# bugs are mine

class site_facts::installed_packages {

  file { '/var/lib/misc/thishost':
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
  }

  -> file { '/etc/apt/apt.conf.d/local-pkglist':
    source => "puppet:///modules/${module_name}/local-pkglist",
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  -> exec { 'dpkg list':
    command => '/usr/bin/dpkg-query -W -f \'${Package}\n\' > /var/lib/misc/thishost/pkglist',  # lint:ignore:single_quote_string_with_variables
    creates => '/var/lib/misc/thishost/pkglist',
  }

}
