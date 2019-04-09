# === Copyright
#
# Copyright Dennis Philpot
#
class nullmailer::config (
  $adminaddr = $::nullmailer::adminaddr,
  $defaultdomain = $::nullmailer::defaultdomain,
  $remotes = $::nullmailer::remotes,
  $me = $::nullmailer::me,
) {
  File {
    ensure => 'file',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/nullmailer':
    ensure => 'directory',
  }

  if $me and $me != '' {
    file { '/etc/nullmailer/me':
      content => "${me}\n",
    }
  } else {
    file { '/etc/nullmailer/me':
      ensure => 'absent',
    }
  }

  file { '/etc/nullmailer/adminaddr':
    content => "${adminaddr}\n",
  }

  file { '/etc/nullmailer/defaultdomain':
    content => "${defaultdomain}\n";
  }

  file { '/etc/nullmailer/remotes':
    content => template('nullmailer/remotes.erb');
  }

  file { '/etc/mailname':
    content => "${defaultdomain}\n";
  }
}
