# This class manages the puppet agent
#
# @param services services to disable
# @param packages packages to remove
#

class site_puppet (
  Array $services,
  Array $packages,
) {

  create_resources(package, $packages, {'ensure' => 'purged'})
  create_resources(service, $services, {'ensure' => 'stopped', 'enable' => false})

  $content = "2 */2 * * * root chronic puppet agent --verbose --onetime --no-daemonize --show_diff\n"

  file { '/etc/cron.d/puppet-agent':
    ensure  => file,
    content => $content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['moreutils', 'puppet'],
  }

}
