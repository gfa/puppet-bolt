# this class stops fail2ban


class profile::networking::firewall::fail2ban::stop {

  # tried many things but either
  # - fail2ban rules are saved to disk
  # - fail2ban breaks because rules/chains are missing
  # sadly, the most reliable thing to do is restart fail2ban
  #
  # fail2ban >=0.10.2 restores the banned hosts after restart :)

  exec { 'stop_fail2ban':
    command => '/usr/sbin/invoke-rc.d fail2ban stop || true',
  }

}
