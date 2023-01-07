# this class configures a prometheus server
#
#
class site_prometheus {

  package { ['prometheus', 'prometheus-alertmanager']: }

}
