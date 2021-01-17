# frozen_string_literal: true

require 'facter'

Facter.add(:dpkgs) do
  setcode do
    installed_packages = {}
    all_packages = Facter::Util::Resolution.exec('dpkg-query --show')
    packages = all_packages.split("\n")
    packages.each do |pkg|
      package_version = pkg.split("\t")
      package = (package_version[0]).strip
      version = (package_version[1]).strip
      installed_packages[package] = version
    end
    installed_packages
  end
end
