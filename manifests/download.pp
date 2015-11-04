#
#
#

class jolokia::download {

#  $version = '1.2.2'
#  $version = '1.3.0'

  $file    = "jolokia-${jolokia::version}-bin.tar.gz"

  $source  = "https://github.com/rhuss/jolokia/releases/download/v${jolokia::version}/${file}"

  wget::fetch { "download ${file}":
    source      => "${source}",
    destination => "/var/tmp/${file}",
    verbose     => false
  }

  exec { "unzip jolokia":
    path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
    command => "tar -xzf /var/tmp/${file} -C /var/tmp/",
    onlyif  => "test ! -d /var/tmp/jolokia-${jolokia::version}",
    require => [
      Wget::Fetch["download ${file}"],
#      Package['unzip']
    ]
  }


}

# EOF
