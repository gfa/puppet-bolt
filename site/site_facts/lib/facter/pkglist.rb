# see site/base/manifests/facts/installed_packages.pp
# frozen_string_literal: true

pkglist = '/var/lib/misc/thishost/pkglist'

if FileTest.exist?(pkglist)
  Facter.add('pkglist') do
    setcode do
      File.open(pkglist).read.split("\n").join(' ')
    end
  end
end
