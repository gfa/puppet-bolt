# Wrapper class to configure unattended upgrades from hiera
#
# @param configuration contains unattended upgrades configuration as a hash
#

class base::unattended_upgrades (
  Hash $configuration
) {

  class { 'unattended_upgrades':
    auto    => {
      'reboot'      => $configuration['auto']['reboot'],
      'reboot_time' => $configuration['auto']['reboot_time'],
    },

    origins => $configuration['origins'],

    mail    => {
      only_on_error => true,
      to            => 'root',
    },
  }

}
