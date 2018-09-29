# This class installs all the packages I want on _all_ machines
#

class packages {
  create_resources(package, $packages, {'ensure' => 'present'})
}
