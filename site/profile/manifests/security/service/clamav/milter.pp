# this class manages clamav milter
# it expects clamd to run in the same machine
#
# @param allow_connections_from an array of ip4 addr that are allowed to connect
# @param port port where the milter will listen
# @param listen_on ip4 address on which the milter will listen for connections
# @param whitelist_addresses To: and From: email addresses to whitelist
#
# TODO: there is a lot of hardcoded stuff in here

class profile::security::service::clamav::milter (
  Array[IP::Address::V4] $allow_connections_from = ['127.0.0.1'],
  IP::Address::V4 $listen_on = '127.0.0.1',
  Integer $port = 3310,
  String $whitelist_addresses = undef,
) {

  package { 'clamav-milter':
    ensure => present,
  }

  $config_options = {
    'AddHeader'                 => 'Replace',
    'ClamdSocket'               => 'unix:/var/run/clamav/clamd.ctl',
    'FixStaleSocket'            => true,
    'Foreground'                => false,
    'LogClean'                  => 'Off',
    'LogFacility'               => 'LOG_LOCAL6',
    'LogFileMaxSize'            => '1M',
    'LogFileUnlock'             => false,
    'LogInfected'               => 'Off',
    'LogRotate'                 => true,
    'LogSyslog'                 => true,
    'LogTime'                   => true,
    'LogVerbose'                => false,
    'MaxFileSize'               => '25M',
    'MilterSocket'              => "inet:${port}@${$listen_on}",
    'MilterSocketGroup'         => 'clamav',
    'MilterSocketMode'          => '666',
    'OnClean'                   => 'Accept',
    'OnFail'                    => 'Defer',
    'OnInfected'                => 'Reject',
    'PidFile'                   => '/var/run/clamav/clamav-milter.pid',
    'ReadTimeout'               => 120,
    'SupportMultipleRecipients' => true,
    'TemporaryDirectory'        => '/tmp',
    'User'                      => 'clamav',
    'Whitelist'                 => '/etc/clamav/whitelist',
  }

  service { 'clamav-milter':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [Package['clamav-milter'], File['/etc/clamav/clamav-milter.conf']],
  }

  file { '/etc/clamav/clamav-milter.conf':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('clamav/clamav.conf.erb'),
    notify  => Service['clamav-milter'],
  }

  file { '/etc/clamav/whitelist':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => $whitelist_addresses,
    notify  => Service['clamav-milter'],
  }

  firewall_multi { '300 Allow network access to clamav-milter':
    chain    => 'INPUT',
    dport    => $port,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    source   => $allow_connections_from,
  }

}
