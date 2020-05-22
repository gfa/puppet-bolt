# this class manages diffie hellman (dh) files for postfix

class postfix::dh (
  Stdlib::Absolutepath $postfix_dh512 = '/etc/postfix/dh512.pem',
  Stdlib::Absolutepath $postfix_dh1024 = '/etc/postfix/dh2048.pem',
) {

  openssl::dhparam { $postfix_dh512:
    size =>  512,
  }

  openssl::dhparam { $postfix_dh1024:
    size =>  2048,
  }

}
