# main class for needrestart
#
# Parameters:
# [*configs*]
#   hash of configuration parameters to overwrite from default.
#   Example (hiera):
#   needrestart::configs:
#     ui_mode: 'a'
#     restart: 'l'
#     defno: 0
#     blacklist:
#       - 'qr(^/usr/bin/sudo(\.dpkg-new)?$)'
#       - 'qr(^/sbin/(dhclient|dhcpcd5|pump|udhcpc)(\.dpkg-new)?$)'
#     override_rc:
#       'qr(^dbus)': 0
#       'qr(^gdm)': 0
class needrestart(
  $package_ensure                = $needrestart::params::package_ensure,
  $package_name                  = $needrestart::params::package_name,
  $configs                       = {},
) inherits needrestart::params {


  $install = false

  case $::operatingsystem {
    'Debian': {
      $_install = true
    }

    'Ubuntu': {
      if versioncmp($::lsbdistrelease, '16.04') >= 0 {
        $_install = true
      }
    }

    default: {
        $_install = $install
      notice ("Your operating system ${::operatingsystem} is not supported by this module")
    }
  }

  if $_install {
    include needrestart::install
    include needrestart::config
  }
}
