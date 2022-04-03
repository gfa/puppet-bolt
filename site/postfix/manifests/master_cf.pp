# this class manages master.cf
#
class postfix::master_cf {

  $postfix::config.keys().each |$instance| {

    # postfix documentation refers to /etc/postfix as the primary instance
    if $instance == 'primary' {
      $suffix = undef
    } else {
      $suffix = "-${instance}"
    }

    file { "/etc/postfix${suffix}/master.cf":
      ensure  => file,
      content => template("${module_name}/master.cf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service["postfix${suffix}"],
    }

  }
}
