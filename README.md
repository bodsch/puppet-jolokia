# puppet-jolokia

Puppet Module for deployment of jolokia Application



# usage

## hiera
```
jolokia::name: 'jolokia'

jolokia::catalina_base: '/opt/apache-tomcat/jolokia'
jolokia::setenv: "%{hiera('jolokia::catalina_base')}/bin/setenv.sh"
jolokia::logdir: "/var/log/tomcat"

tomcat::instance::logdir: "%{hiera('jolokia::logdir')}/jolokia"

jolokia::owner: tomcat
jolokia::group: tomcat

tomcat::instance:
  'jolokia':
    catalina_base: "%{hiera('tomcat::catalina_base')}"
    source_url: 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz'

tomcat::service:
  'jolokia':
    use_init: true
    service_ensure: stopped
    service_enable: false
    service_name: 'tomcat-jolokia'
    catalina_base: "%{hiera('tomcat::catalina_base')}"

tomcat::config::server:
  'jolokia':
    catalina_base: "%{hiera('tomcat::catalina_base')}"
    address: '127.0.0.1'

tomcat::setenv::entry:
  'CATALINA_OPTS':
    config_file: "%{hiera('tomcat::setenv')}"
    quote_char: '"'
    value: "-Xms32m -Xmx32m -Xss256k -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSClassUnloadingEnabled -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:%{hiera('jolokia::logdir')}/jolokia/gc.out"
  'CATALINA_OUT':
    config_file: "%{hiera('tomcat::setenv')}"
    quote_char: '"'
    value: "%{hiera('jolokia::logdir')}/jolokia/catalina.out"
  'CATALINA_PID':
    config_file: "%{hiera('tomcat::setenv')}"
    quote_char: '"'
    value: '/var/run/tomcat-jolokia.pid'

tomcat::war:
  'jolokia.war':
    catalina_base: "%{hiera('tomcat::catalina_base')}"
    war_source: '/opt/install/jolokia-1.3.0/agents/jolokia.war'

# --------------------------------------------------------------

```

