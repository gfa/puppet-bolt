# this class configures fail2ban for roundcube
#

class profile::networking::firewall::fail2ban::roundcube {

  include profile::networking::firewall::fail2ban

  $roundcube_params = lookup('fail2ban::jail::roundcube-auth')
  fail2ban::jail { 'roundcube-auth':
    backend => '%(syslog_backend)s',
    *       => $roundcube_params,
  }

}
