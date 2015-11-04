#
#
#

class jolokia::config {


  class { 'tomcat':
    catalina_home  => $jolokia::catalina_home,
    user           => $jolokia::owner,
    group          => $jolokia::group,
    manage_user    => false,
    manage_group   => false,
  } ->
  tomcat::instance { 'jolokia':
    catalina_base  => "${jolokia::catalina_base}",
    source_url     => 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz',
    require        => Class['tomcat']
  } ->
  tomcat::config::server { 'jolokia':
    catalina_base  => "${jolokia::catalina_base}",
    address        => '127.0.0.1',
    require        => Tomcat::Instance['jolokia'],
    notify         => Class['jolokia::service']
  }

  tomcat::setenv::entry { 'CATALINA_OPTS':
    config_file    => $jolokia::params::setenv,
    quote_char     => '"',
    value          => "-Xms32m -Xmx32m -Xss256k -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSClassUnloadingEnabled -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:${jolokia::logdir_jolokia}/gc.out",
    require        => Tomcat::Instance['jolokia'],
#    notify         => Service['jolokia']
  }
  tomcat::setenv::entry { 'CATALINA_OUT':
    config_file    => $jolokia::params::setenv,
    quote_char     => '"',
    value          => "${jolokia::logdir_jolokia}/catalina.out",
    require        => Tomcat::Instance['jolokia'],
#    notify         => Service['jolokia']
  }
  tomcat::setenv::entry { 'CATALINA_PID':
    config_file    => $jolokia::params::setenv,
    quote_char     => '"',
    value          => '/var/run/tomcat-jolokia.pid',
    require        => Tomcat::Instance['jolokia'],
#    notify         => Service['jolokia']
  }

  file { "${jolokia::catalina_base}/logs":
    ensure  => link,
    target  =>  "${jolokia::logdir_jolokia}",
    force   => true,
    owner    => $jolokia::owner,
    group    => $jolokia::group,
    require => [
      User[ $jolokia::owner ],
      Group[ $jolokia::group ],
      Class['tomcat'],
      Tomcat::Instance['jolokia']
    ]
  }

  tomcat::war { 'jolokia.war':
    catalina_base  => "${jolokia::catalina_base}",
    war_source     => "/var/tmp/jolokia-${jolokia::version}/agents/jolokia.war",
    require        => [
      Tomcat::Instance['jolokia'],
      Exec[ "unzip jolokia" ]
    ],
#    notify         => Service['jolokia']
  }

}

# EOF




