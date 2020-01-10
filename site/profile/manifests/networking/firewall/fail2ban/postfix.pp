# this class configures fail2ban for postfix
#

class profile::networking::firewall::fail2ban::postfix {

  include profile::networking::firewall::fail2ban

  fail2ban::filter { 'postfix-sasl':
    failregexes   => [
      '^postfix(-\w+)?/(?:submission/|smtps/)?smtp[ds] warning: [-._\w]+\[<HOST>\]: SASL ((?i)LOGIN|PLAIN|(?:CRAM|DIGEST)-MD5) authentication failed(:[ A-Za-z0-9+/:]*={0,2})?\s*$',
    ],
    ignoreregexes => [
      'authentication failed: Connection lost to authentication server$',
    ],
  }

  $postfix_sasl_params = lookup('fail2ban::jail::postfix-sasl')
  fail2ban::jail { 'postfix-sasl':
    action => 'iptables-multiport[name=postfix-sasl, port="smtp,submission,imap,imaps,sieve", protocol=tcp]
         blocklist_de[service=postfix]',
    *      => $postfix_sasl_params,
  }

  fail2ban::filter { 'postfix-auth':
    failregexes => [
      'lost connection after AUTH from (.*)\[<HOST>\]',
    ],
  }

  fail2ban::jail { 'postfix-auth':
    port    => 'smtp,submission,imap,imaps,sieve',
    filter  => 'postfix-auth',
    logpath => '%(postfix_log)s',
    backend => '%(postfix_backend)s',

  }

}
