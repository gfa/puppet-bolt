# This class enables the puppet agent
#

class base::enable_puppet {

  service { 'puppet':
    ensure => running,
    enable => true,
  }

  service { 'mcollective':
    ensure => stopped,
    enable => false,
  }

}
