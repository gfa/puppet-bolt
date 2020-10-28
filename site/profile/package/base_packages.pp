# This class installs packages common to  _all_ machines
#
# @param base Contains base packages to install everywhere
# @param remove Contains packages to remove everywhere
#

class profile::package::base_packages (
  Hash[String, Hash] $base,
  Hash[String, Hash] $remove,
) {

  # this forces a dependency from any package to
  # apt::update https://redd.it/errr4u
  Class['apt::update'] -> Package <| tag == 'apt' |>

  create_resources(package, $base, {
      'ensure' => 'present',
      require  => Class['profile::package::pinning'],
  })

  create_resources(package, $remove, {
      'ensure' => 'purged',
  })

}
