{
  "type" : "read",
  "mbean" : "com.coremedia:application=contentfeeder,type=Feeder",
  "attribute" : [
    "State",
    "Uptime",
    "CurrentPendingDocuments",
    "IndexAverageBatchSendingTime",
    "IndexDocuments",
    "IndexContentDocuments",
    "IndexBytes",
    "LatestIndexing",
    "PendingEvents",
    "PendingFolders"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
