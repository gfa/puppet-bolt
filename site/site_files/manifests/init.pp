# this class copies files and defines their permissions from hiera
#
# example
# site_files::files:
#   /etc/vim/vimrc.local:
#     owner: root
#     group: root
#     mode: 0644
#     content: |
#     syntax on
#      set background=dark
#   /etc/vim/vimrc.local2:
#    content: |
#      dummy file as example
#      if perms and ownership are not defined
#      defaults will be used

# @param files a hash containing files, their permissions, ownership and contents

define site_files (
  Variant[Hash, Type[Undef]] $files = lookup({
      name          => 'site_files::files',
      merge         => 'deep',
      default_value => Undef,
  })
) {

  if $files != Undef {
    $files.each |$path, $data| {
      file { $path:
        ensure  => $data['ensure'],
        owner   => $data['owner'],
        group   => $data['group'],
        mode    => $data['mode'],
        content => $data['content'],
      }
    }
  }
}
