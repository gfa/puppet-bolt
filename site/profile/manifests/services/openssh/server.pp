# this class manages the openssh server
# it doesn't do much as most configuration details are stored in hiera
#

class profile::services::openssh::server {

  class { 'ssh':
    validate_sshd_file => true,
  }

}
