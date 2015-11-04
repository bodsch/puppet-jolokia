{
  "type" : "read",
  "mbean" : "com.coremedia:application=coremedia,type=Server",
  "attribute" : [
    "RunLevel",
    "ResourceCacheHits",
    "ResourceCacheEvicts",
    "ResourceCacheEntries",
    "ConnectionCount",
    "RunLevel"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
