# this class configures fail2ban for dovecot
#

class profile::networking::firewall::fail2ban::dovecot {

  include profile::networking::firewall::fail2ban

  $dovecot_params = lookup('fail2ban::jail::dovecot')
  fail2ban::jail { 'dovecot':
    *      => $dovecot_params,
  }

}
