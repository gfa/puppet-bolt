# this class configures the root account
# it is a thin wrapper around the root module
#
# @param node_ssh_authorized_keys per node pub ssh keys to add to /root/.ssh/authorized_keys
# @param base_ssh_authorized_keys pub ssh keys to add on all nodes to /root/.ssh/authorized_keys

class profile::security::account::root (
  Array $base_ssh_authorized_keys,
  Array $node_ssh_authorized_keys = [],
) {

  $ssh_authorized_keys = join(
    [
      '# DO not edit, managed by puppet',
      $base_ssh_authorized_keys,
      $node_ssh_authorized_keys,
      "\n",
    ],
    "\n",
  )

  class { 'root':
    ssh_authorized_keys_content => $ssh_authorized_keys,
  }

}
