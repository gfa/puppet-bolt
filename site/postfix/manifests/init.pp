# this module manages postfix

#
# @param config contains the postfix configuration as key=values
# @param packages contains the postfix packages to install
#

class postfix (
  Hash $config,
  Array[String] $packages = 'postfix',
)  {

  contain postfix::install
  contain postfix::main_cf
  #contain postfix::master_cf
  contain postfix::dh
  contain postfix::service

  Class['postfix::install']
  ~> Class['postfix::dh']
  -> Class['postfix::main_cf']

}
