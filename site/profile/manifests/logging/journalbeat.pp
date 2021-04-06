# this class configures journalbeat
#

class profile::logging::journalbeat {

  if $facts['os']['architecture'] == 'amd64' {
    apt::source { 'elastic':
      # location => https://artifacts.elastic.co/packages/7.x/apt,  # gratis repo
      location => 'https://artifacts.elastic.co/packages/oss-7.x/apt', # FOSS only repo
      release  => 'stable',
      repos    => 'main',
      # require  => Package['apt-transport-https'],
      key      => {
        'id'   => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
        source => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
      },
    }

    package { 'journalbeat':
      require => Apt::Source['elastic'],
    }

    service { 'journalbeat':
      ensure  => running,
      enable  => true,
      require => Package['journalbeat'],
    }

    file { '/etc/journalbeat/journalbeat.yml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => epp("${module_name}/etc/journalbeat/journalbeat.yml.epp"),
      notify  => Service['journalbeat'],
      require => Package['journalbeat'],
    }
  }

}
