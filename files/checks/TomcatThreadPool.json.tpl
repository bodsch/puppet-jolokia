{
  "type" : "read",
  "mbean" : "Catalina:type=Executor,name=tomcatThreadPool",
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
