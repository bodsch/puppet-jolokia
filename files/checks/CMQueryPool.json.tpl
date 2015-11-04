{
  "type" : "read",
  "mbean" : "com.coremedia:application=coremedia,bean=QueryPool,type=Store",
  "attribute" : [
    "IdleExecutors",
    "RunningExecutors",
    "WaitingQueries",
    "MaxQueries"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
