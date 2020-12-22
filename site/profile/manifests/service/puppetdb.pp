# this class manages puppetdb
#

class profile::service::puppetdb {

    class { 'puppetdb::server':
        vardir  => '/var/lib/puppetdb',
        confdir => '/etc/puppetdb/conf.d',
    }

    class { 'puppetdb::database::postgresql':
      manage_package_repo => false,
      postgres_version    => '11',
      manage_server       => true,
    }

}
