{
  "type" : "read",
  "mbean" : "com.coremedia:application=coremedia,bean=ConnectionPool,type=Store",
  "attribute" : [
    "BusyConnections",
    "OpenConnections",
    "IdleConnections",
    "MaxConnections",
    "MinConnections"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
