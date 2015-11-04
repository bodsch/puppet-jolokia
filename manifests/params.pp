#
#
#

class jolokia::params {

  $logdir         = '/var/log/tomcat'
  $logdir_jolokia = '/var/log/tomcat/jolokia'
  $catalina_home  = '/opt/apache-tomcat'
  $catalina_base  = '/opt/apache-tomcat/jolokia'
  $cronjob        = false

  $setenv         = "$catalina_base/bin/setenv.sh"

  $owner          = 'tomcat'
  $group          = 'tomcat'

}

# EOF
