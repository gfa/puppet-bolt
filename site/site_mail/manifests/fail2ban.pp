# this class configures fail2ban, jails used on mail servers
#

class site_mail::fail2ban {

  include site_firewall::fail2ban

  $dovecot_params = lookup('fail2ban::jail::dovecot')
  fail2ban::jail { 'dovecot':
    filter => 'sshd[mode=aggressive]',
    *      => $dovecot_params,
  }

  $postfix_sasl_params = lookup('fail2ban::jail::postfix-sasl')
  fail2ban::jail { 'postfix-sasl':
    action => 'iptables-multiport[name=postfix-sasl, port="smtp,submission,imap,imaps,sieve", protocol=tcp]\n
              blocklist_de[service=postfix]',
    *      => $postfix_sasl_params,
  }

  $roundcube_params = lookup('fail2ban::jail::roundcube-auth')
  fail2ban::jail { 'roundcube-auth':
    backend => '%(syslog_backend)s',
    *       => $roundcube_params,
  }

  fail2ban::filter { 'postfix-auth':
    failregexes => [
      'lost connection after AUTH from (.*)\[<HOST>\]',
    ],
  }

  -> fail2ban::jail { 'postfix-auth':
    port    => 'smtp,submission,imap,imaps,sieve',
    filter  => 'postfix-auth',
    logpath => '%(postfix_log)s',
    backend => '%(postfix_backend)s',

  }

}

