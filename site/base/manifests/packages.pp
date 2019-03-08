# This class installs all the packages I want on _all_ machines
#
# @param base Contains base packages to install everywhere
#

class base::packages (
  Hash[String, Hash] $base,
) {

  create_resources(package, $base, {'ensure' => 'present'})

}
