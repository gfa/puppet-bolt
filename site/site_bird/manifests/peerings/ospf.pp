# this class configures ospf
#
# @param peerings I'm reusing the Array[Hash] of bird/wg to define on which wg interfaces should ospf run
#

class site_bird::peerings::ospf (
  Optional[Array] $peerings = lookup('site_bird::peerings', default_value => undef),
) {

  if $peerings {

    file { '/etc/bird/ospf.conf':
      owner   => 'root',
      group   => 'bird',
      mode    => '0640',
      content => epp("${module_name}/etc/bird/ospf.conf.epp", {'peerings' => $peerings}),
      notify  => Service['bird'],
      require => Package['bird2'],
    }
  }
}
