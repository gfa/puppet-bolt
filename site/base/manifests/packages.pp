# This class installs all the packages I want on _all_ machines
#
# @param packages Contains base packages to install everywhere
#

class base::packages (
  Hash[String, Hash] $packages,
) {

  create_resources(package, $packages, {'ensure' => 'present'})

}
