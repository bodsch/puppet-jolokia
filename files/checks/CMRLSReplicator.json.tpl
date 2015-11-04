{
  "type" : "read",
  "mbean" : "com.coremedia:type=Replicator,application=coremedia",
  "attribute" : [
    "ConnectionUp",
    "ControllerState",
    "Enabled",
    "PipelineUp",
    "IncomingCount",
    "CompletedCount",
    "UncompletedCount",
    "LatestCompletedSequenceNumber",
    "LatestCompletedArrival",
    "LatestCompletionDuration",
    "LatestIncomingSequenceNumber",
    "LatestIncomingArrival"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
