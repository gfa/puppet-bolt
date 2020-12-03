# this class manages smartctl

class profile::hardware::smartctl {

  if $facts['is_virtual'] == true {

    package {'smartmontools':
      ensure => purged,
    }

  } else {

    if $facts['architecture'] == 'amd64' {
      if $facts['dmi']['manufacturer'] != 'Joyent' {
        package {'smartmontools':
          ensure => present,
        }
      }
    } else {
      package {'smartmontools':
        ensure => present,
      }
    }
  }
}
