# this module manages local facts
#

class site_facts {

  include site_facts::installed_packages

  file { '/var/tmp/puppet-facts':
    ensure    => file,
    mode      => '0600',
    owner     => 'root',
    group     => 'root',
    show_diff => false,
    content   => epp("${module_name}/var/tmp/puppet-facts.epp"),
  }
}
