# manages some bits around etckeeper
#

class profile::package::etckeeper {

  file_line { 'Append a line to /etc/.gitignore':
    path    => '/etc/.gitignore',
    line    => "puppet/*\n",
    match  => '^puppet\/\*$',
    require => Package['etckeeper'],
  }

}
