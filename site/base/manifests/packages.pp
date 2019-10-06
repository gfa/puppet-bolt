# This class installs all the packages I want on _all_ machines
#
# @param base Contains base packages to install everywhere
#

class base::packages (
  Hash[String, Hash] $base,
) {

  create_resources(package, $base, {'ensure' => 'present'})

  apt::pin { 'backports':
    packages => [
      'fail2ban',
      'ipset-persistent',
      'iptables-persistent',
      'netfilter-persistent',
      'facter',
      'prosody',
      'prosody-modules',
      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=941414
      'dehydrated',
    ],
    priority => 990,
    release  => "${facts['os']['distro']['codename']}-backports",
  }

}
