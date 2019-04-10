# This class manages interactive machines
# takes configuration parameters from hiera
# and passes them to other classes in the module
#
# @param packages Packages to install
#

class interactive (
  Hash[String, Hash] $packages,
) {

  class { 'interactive::packages':
    packages => $packages,
  }

}
