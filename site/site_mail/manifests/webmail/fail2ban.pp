# this class configures fail2ban, jails used on webmails
#

class site_mail::webmail::fail2ban {

  include site_mail::fail2ban

  $roundcube_params = lookup('fail2ban::jail::roundcube-auth')
  fail2ban::jail { 'roundcube-auth':
    backend => '%(syslog_backend)s',
    *       => $roundcube_params,
  }

}
