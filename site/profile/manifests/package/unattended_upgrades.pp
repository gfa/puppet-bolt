# Wrapper class to configure unattended upgrades from hiera
#
# @param configuration contains unattended upgrades configuration as a hash
#

class profile::package::unattended_upgrades (
  Hash $configuration
) {

  class { 'unattended_upgrades':
    # this is ugly, find a way to pass whatever is in hiera.

    auto                   => {
      'reboot'      => $configuration['auto']['reboot'],
      'reboot_time' => $configuration['auto']['reboot_time'],
    },

    origins                => $configuration['origins'],

    mail                   => {
      only_on_error => true,
      to            => 'root',
    },

    remove_new_unused_deps => $configuration['remove_new_unused_deps'],
    remove_unused_kernel   => $configuration['remove_unused_kernel'],

  }

  service { 'unattended-upgrades':
    ensure => stopped,
    enable => false,
  }

}
