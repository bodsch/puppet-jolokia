{
  "type" : "read",
  "mbean" : "com.coremedia:type=ProactiveEngine,application=caefeeder",
  "attribute" : [
    "KeysCount",
    "ValuesCount",
    "InvalidationCount",
    "SendSuccessTimeLatest",
    "PurgeTimeLatest",
    "HeartBeat",
    "QueueCapacity",
    "QueueMaxSize",
    "QueueProcessedPerSecond"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
