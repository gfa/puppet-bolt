# this class manages smartctl

class profile::hardware::smartctl {

  if $facts['is_virtual'] == true {

    package{'smartmontools':
      ensure => absent,
    }

  } else {

    package{'smartmontools':
      ensure => present,
    }

  }

}
