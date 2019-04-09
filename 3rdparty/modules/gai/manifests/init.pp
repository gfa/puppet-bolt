# init.pp --- Class gai
#
# @summary Manage /etc/gai.conf
#
# @example Declaring the class
#
#   class { 'gai': }
#
# @param label
#   A hash with netmask/precedence pairs for the label table.
#
# @param precedence
#   A hash with netmask/precedence pairs for the precedence table.
#
# @param scopev4
#   A hash with mask/value pairs for the scope table.
#
# @param reload
#   Indicate if the config should be reloaded for every loopkup.
#   Valid options: 'yes', 'no' or undefined. Default: undef
#
#
class gai (
  Hash[String,String]        $label      = {},
  Hash[String,String]        $precedence = {},
  Hash[String,String]        $scopev4    = {},
  Optional[Enum['yes','no']] $reload     = undef,
) {

  # Declaring the class without any parameters will create the file
  # /etc/gai.conf containing comments only. In this case the operating
  # system specific default rules apply. See RFC 3484 for details.

  file { '/etc/gai.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('gai/gai.conf.erb'),
  }
}
