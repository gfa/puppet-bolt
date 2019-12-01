# this class configures an email server using postfix
#

class profile::service::postfix (

) {

  include postfix

  class  { 'postfix':
    master_smtp       => 'smtp inet n - y - - smtpd',
    master_smtps      => '',
    master_submission => "submission inet n       -       n       -       -       smtpd \n
      -o content_filter= \n
      -o syslog_name=postfix/submission
      -o smtpd_recipient_restrictions=permit_sasl_authenticated,permit_tls_clientcerts,permit_mynetworks,reject
      -o smtpd_sender_restrictions=permit_sasl_authenticated,permit_tls_clientcerts,permit_mynetworks,reject
      -o smtpd_tls_req_ccert=no
      -o smtpd_tls_ask_ccert=yes
      -o smtpd_tls_auth_only=yes
      -o smtpd_tls_security_level=encrypt
      -o tls_preempt_cipherlist=yes
      -o smtpd_tls_fingerprint_digest=sha1
      -o smtpd_relay_restrictions=permit_sasl_authenticated,permit_tls_clientcerts,permit_mynetworks,reject
      # si quiero solo aceptar certs firmados por mi, aca lo hago.
      # -o smtpd_tls_CAfile=/etc/ssl/smtp-keys/keys/ca.crt
      # -o smtpd_client_restrictions=permit_tls_all_clientcerts
      -o smtpd_client_restrictions=
      -o smtpd_helo_restrictions=
      -o smtpd_data_restrictions=
      # http://irbs.net/internet/postfix/0511/1603.html
      # http://askubuntu.com/questions/78163/when-sending-email-with-postfix-how-can-i-hide-the-sender-s-ip-and-username-in
      -o smtpd_reject_unlisted_sender=yes
      -o smtpd_reject_unlisted_recipient=no
      -o non_smtpd_milters=inet:localhost:8892
      -o smtpd_milters=inet:localhost:8892",

  }

}
