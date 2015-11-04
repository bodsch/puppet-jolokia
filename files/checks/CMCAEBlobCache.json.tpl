{
  "type" : "read",
  "mbean" : "com.coremedia:type=CapConnection,application=blueprint",
  "attribute" : [
    "BlobCacheSize",
    "BlobCacheLevel",
    "BlobCacheFaults",
    "HeapCacheSize",
    "HeapCacheLevel",
    "HeapCacheFaults"
  ],
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://localhost:%PORT%/jmxrmi", }
}
