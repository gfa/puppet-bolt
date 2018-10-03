# this class provides local configuration for mysql
#
# @param mysql_root_password The mysql root password
# @param override_options Options to pass to the mysql server
# @param restart Is the module allowed to restart the server, true/false as _string_
#

class site_mysql::server (
  String $mysql_root_password,
  Hash $override_options,
  String $restart,
) {

  class { '::mysql::server':
    root_password           => $mysql_root_password,
    remove_default_accounts => true,
    override_options        => $override_options,
    restart                 => $restart,
  }

}
