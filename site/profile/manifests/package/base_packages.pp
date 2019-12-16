# This class installs packages common to  _all_ machines
#
# @param base Contains base packages to install everywhere
#

class profile::package::base_packages (
  Hash[String, Hash] $base,
) {

  create_resources(package, $base, {
    'ensure' => 'present',
    require  => Class['profile::package::pinning'],
    })

}
