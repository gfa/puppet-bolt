# this class configures fail2ban for postfix
#

class profile::networking::firewall::fail2ban::postfix {

  include profile::networking::firewall::fail2ban

  fail2ban::filter { 'postfix-sasl':
    failregexes => [
      'postfix(-\w+)?/(?:submission/|smtps/)?smtp[ds]\[[0-9]+\]: warning: [-._\w]+\[<HOST>\]: SASL ((?i)LOGIN|PLAIN|(?:CRAM|DIGEST)-MD5) authentication failed(:[ A-Za-z0-9+\/:]*={0,2})?\s*$'  # lint:ignore:140chars
    ],
  }

  $postfix_sasl_params = lookup('fail2ban::jail::postfix-sasl')
  fail2ban::jail { 'postfix-sasl':
    filter => 'postfix-sasl',
    *      => $postfix_sasl_params,
  }

  fail2ban::filter { 'postfix-brute':
    failregexes => [
      'postfix(-\w+)?/(?:submission/|smtps/)?smtp[ds]\[[0-9]+\]: NOQUEUE: reject: RCPT from [-._\w]+\[<HOST>]: 550 5.1.1'
    ]
  }

  $postfix_extra_params = {
    'bantime'  => 420,
    'findtime' => 360,
    'maxretry' => 2,
  }
  $postfix_params = lookup('fail2ban::jail::postfix') + $postfix_extra_params
  fail2ban::jail { 'postfix':
    filter => 'postfix-brute',
    *      => $postfix_params,
  }

}
