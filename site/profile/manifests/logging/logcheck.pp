# this configures logcheck
#
# @param content content of /etc/logcheck/logcheck.conf in site_files format
#

class profile::logging::logcheck (
  Hash $content,
) {

  site_files { 'logcheck':
    files => $content,
  }

}
