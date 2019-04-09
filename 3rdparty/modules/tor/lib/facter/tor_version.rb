Facter.add(:tor_version) do
  setcode do
    if Facter::Util::Resolution.which('tor')
      tor_version = Facter::Util::Resolution.exec('tor --version 2>&1')
      Facter.debug "Parsing Tor version '#{tor_version}'"
      %r{^Tor version (\d+.\d+.\d+(.\d+)?)}.match(tor_version)[1]
    end
  end
end
