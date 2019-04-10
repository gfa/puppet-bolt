# This class manages the puppet agent
#
# @param services services to disable
# @param packages packages to remove
#

class site_puppet (
  Array $services,
  Array $packages,
) {

  $services.each | Integer $index, String $value | {
    service { $value:
      ensure => stopped,
      enable => false,
    }
  }

  $packages.each | Integer $index2, String $package | {
    package { $package:
      ensure => purged,
    }
  }

  $content = "2 */2 * * * root chronic puppet agent --verbose --onetime --no-daemonize --show_diff\n"

  file { '/etc/cron.d/puppet-agent':
    ensure  => absent,
  }

}
