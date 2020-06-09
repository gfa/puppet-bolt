# this class manages smartctl

class profile::hardware::smartctl {

  if $facts['is_virtual'] == true {

    package{'smartmontools':
      ensure => purged,
    }

  } else {

    package{'smartmontools':
      ensure => present,
    }

  }

}
