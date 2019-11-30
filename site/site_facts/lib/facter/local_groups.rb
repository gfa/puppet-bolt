# frozen_string_literal: true

require 'etc'

Facter.add(:local_groups) do
  setcode do
    local_groups = {}

    Etc.group do |g|
      name = g.name
      passwd = g.passwd
      gid = g.gid
      mem = g.mem
      local_groups[name] = {
        'passwd' => passwd,
        'gid' => gid,
        'mem' => mem
      }
    end
    local_groups
  end
end
