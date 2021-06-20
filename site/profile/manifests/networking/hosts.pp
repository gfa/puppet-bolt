# this class manages /etc/hosts
#

class profile::networking::hosts (
  Optional[Hash] $hosts =  undef,
) {

  if $hosts {
    $hosts.each |$key, $value| {
      host { $key:
        ip => $value,
      }
    }
  }
}
