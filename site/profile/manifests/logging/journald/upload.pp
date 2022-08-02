# this class configures systemd journald upload


class profile::logging::journald::upload (
  Optional[String] $ca = undef,
  Optional[String] $crt = undef,
  Optional[String] $server = undef,
  Optional[String] $key = undef,
) {


  if $key {

    package { 'systemd-journal-remote': }

    File {
      ensure  => file,
      mode    => '0440',
      group   => 'systemd-journal',
      owner   => 'root',
      require => Package['systemd-journal-remote'],
      notify  => Service['systemd-journal-remote'],
    }

    file { '/etc/systemd/journal-remote.key':
      content => $key,
    }

    file { '/etc/systemd/journal-remote.crt':
      content => $crt,
    }

    file { '/etc/systemd/journal-remote.ca':
      content => $ca,
    }

    file { '/etc/systemd/journal-upload.conf':
      ensure  => file,
      content => epp("${module_name}/etc/systemd/journal-upload.conf.epp"),
      notify  => Service['systemd-journal-remote'],
      require => [
        File['/etc/systemd/journal-remote.key'],
        File['/etc/systemd/journal-remote.crt'],
        File['/etc/systemd/journal-remote.ca']],
      mode    => '0440',
      group   => 'systemd-journal',
      owner   => 'root',
    }

    service { 'systemd-journal-upload':
      ensure => running,
      enable => true,
    }

    service { 'systemd-journal-remote':
      ensure => stopped,
      enable => false,
    }

    service { 'systemd-journal-remote.socket':
      ensure => stopped,
      enable => false,
    }

  } else {

    package { 'systemd-journal-remote':
      ensure => purged,
    }

    file { [
      '/etc/systemd/journal-upload.conf',
      '/etc/systemd/journal-remote.key',
      '/etc/systemd/journal-remote.crt',
      '/etc/systemd/journal-remote.ca',
    ]:
      ensure => absent,
    }
  }

}