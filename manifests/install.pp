#
#
#

class jolokia::install {

  group { $jolokia::group:
    ensure => present
  }

  user { $jolokia::owner:
    ensure => present,
    managehome => true,
    comment    => 'system user to run tomcat services',
    home       => "/var/empty/${jolokia::owner}",
    shell      => '/bin/dash',
    require    => Group[ $jolokia::group ]
  }

  file {[ "${jolokia::logdir}", "${jolokia::logdir_jolokia}" ]:
    ensure   => directory,
    recurse  => true,
    force    => true,
    owner    => $jolokia::owner,
    group    => $jolokia::group,
    require  => [
      User[ $jolokia::owner ],
      Group[ $jolokia::group ]
    ]
  }

#  class { 'tomcat':
#    catalina_home  => $jolokia::catalina_base,
#    user           => $jolokia::owner,
#    group          => $jolokia::group,
#    manage_user    => false,
#    manage_group   => false,
#  }

  # jolokia Templates
  file { '/usr/share/jolokia':
    ensure       => directory,
    source       => 'puppet:///modules/jolokia/checks',
    recurse      => true,
  }

  # also used by collectd
  file { '/etc/jolokia.rc':
    ensure   => present,
    source   => 'puppet:///modules/jolokia/etc/jolokia.rc'
  }

  # Check-Script
  file { '/usr/bin/jolokia_checks.sh':
    ensure   => file,
    source   => 'puppet:///modules/jolokia/bin/jolokia_checks.sh',
    mode     => '0775'
  }

  if( $jolokia::cronjob == true ) {

    cron::job { 'run-jolokia-checks':
      description => 'run jolokia-checks to generate monitoring data',
      minute      => '*',
      hour        => '*',
      command     => '/usr/bin/jolokia_checks.sh >> /var/log/jolokia-checks.log 2>&1',
      require     => File['/usr/bin/jolokia_checks.sh']
    }

    cron::job { 'run-cm7-appwatcher':
      description => 'run coremedia application watcher',
      minute      => '*/5',
      hour        => '*',
      command     => '[ -x /usr/local/bin/cm7-appwatcher.sh ] && /usr/local/bin/cm7-appwatcher.sh >> /var/log/cm7-appwatcher.log 2>&1',
    }

  }

}

# EOF
