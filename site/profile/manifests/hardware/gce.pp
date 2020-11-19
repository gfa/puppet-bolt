# IPv6 is broken in GCE

class profile::hardware::gce {

  if $facts['os']['amd64'] and $facts['dmi']['bios']['vendor'] == 'Google' {
      class { 'gai::preferipv4': }
    }

}
