{
  "type" : "read",
  "mbean" : "solr/%SHARD%:type=/replication,id=org.apache.solr.handler.ReplicationHandler",
  "attribute" : "errors,isMaster,isSlave,requests,medianRequestTime",
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
