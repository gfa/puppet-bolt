# this class configure fail2ban for openssh

class profile::networking::firewall::fail2ban::openssh {

  include profile::networking::firewall::fail2ban

  $ssh_params = lookup('fail2ban::jail::sshd')
  fail2ban::jail { 'sshd':
    filter => 'sshd[mode=aggressive]',
    *      => $ssh_params,
  }

}
