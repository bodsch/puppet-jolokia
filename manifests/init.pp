#
#
#

class jolokia (
  $version,
  $logdir         = $jolokia::params::logdir,         # hiera( 'tomcat::logdir', '/var/log/tomcat' )
  $logdir_jolokia = $jolokia::params::logdir_jolokia, # ( 'tomcat::instance::jolokia::logdir' )
  $catalina_base  = $jolokia::params::catalina_base,  # hiera( 'tomcat::catalina_base' )
  $owner          = $jolokia::params::owner,
  $group          = $jolokia::params::group,
  $cronjob        = $jolokia::params::cronjob,
) inherits jolokia::params {

  validate_string( $version )
  validate_absolute_path( $logdir )
  validate_absolute_path( $logdir_jolokia )
  validate_absolute_path( $catalina_base )
  validate_string( $owner )
  validate_string($group )

  $msg = "\nversion: ${version}\nlogdir: ${logdir}\nlogdir_jolokia: ${logdir_jolokia}\ncatalina_base: ${catalina_base}\nowner: ${owner}\ngroup: ${group}\n"
  notify { 'jolokia':
    withpath => false,
    name     => $msg
  }


  contain jolokia::download
  contain jolokia::install
  contain jolokia::config
  contain jolokia::service


#  class { 'jolokia::download': } ->
#  class { 'jolokia::install': } ->
#  class { 'jolokia::config': } ->
#  class { 'jolokia::service': } ->

#  Class['jolokia']

}

# EOF
