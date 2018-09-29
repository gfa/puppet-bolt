# This class manages interactive machines
# @param packages packages to install
#

class interactive::packages (
  Hash[String, Hash] $packages,
) {
  # Install packages
  create_resources(package, $packages, {'ensure' => 'present'})

}
