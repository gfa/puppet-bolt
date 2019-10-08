# This class installs all the packages I want on _all_ machines
#
# @param base Contains base packages to install everywhere
# @param backports Contains packages that should be pinned to -backports
#

class base::packages (
  Hash[String, Hash] $base,
  Array[String] $backports,
) {

  create_resources(package, $base, {'ensure' => 'present'})

  apt::pin { 'backports':
    packages => $backports,
    priority => 990,
    release  => "${facts['os']['distro']['codename']}-backports",
  }

}
