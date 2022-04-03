# this class manages postfix config files
#
class postfix::configure {

  $postfix::config.keys().each |$instance| {

    # postfix documentation refers to /etc/postfix as the primary instance
    if $instance == 'primary' {
      $suffix = undef
    } else {
      $suffix = "-${instance}"
    }

    file { "/etc/postfix${suffix}/main.cf":
      ensure  => file,
      content => template("${module_name}/main.cf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service["postfix${suffix}"],
    }

    file { "/etc/postfix${suffix}/master.cf":
      ensure  => file,
      content => template("${module_name}/master.cf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service["postfix${suffix}"],
    }

    ['relay_clientcerts', 'transport_maps', 'virtual_aliases', 'virtual_mailboxes'].each |$hashed_file| {
      file { "/etc/postfix${suffix}/${hashed_file}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "# puppet managed\n${join($postfix::config[$instance][$hashed_file], " \n")}",
      }

      ~> exec { "hash /etc/postfix${suffix}/${hashed_file}":
        command     => "/usr/sbin/postmap /etc/postfix${suffix}/${hashed_file}",
        refreshonly => true,
      }

    }
  }
}
