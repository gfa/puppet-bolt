# this class configures monitoring for mysql servers
#
# @param links symlinks to create to the mysql_ plugin

class site_mysql::server::monitoring (
  Array $links
) {

  $links.each |$index, $link| {

    munin::plugin { $link:
      ensure => link,
      notify => Service['munin-node', 'munin-async'],
    }
  }

}
