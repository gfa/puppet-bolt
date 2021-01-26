# this class prepares a machine to run erpel
# for now it only creates a user, since all other bits
# are deployed from a pipeline
# vim: set ts=2 sw=2 et :

class profile::logging::erpel {

  group { 'erpel':
    system         => true,
  }

  user { 'erpel':
    system     => true,
    forcelocal => true,
    gid        => 'erpel',
    managehome => true,
    groups     => ['adm','systemd-journal'],
  }

}
