#
#
#

class jolokia::service {

  tomcat::service { 'jolokia':
    use_init         => true,
    service_ensure   => undef,
    service_enable   => true,
    service_name     => 'tomcat-jolokia',
    catalina_base    => "${jolokia::catalina_base}",
    require          => [
      Tomcat::War['jolokia.war'],
      Class['tomcat']
    ]
  }

}

# EOF




