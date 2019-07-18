define apt::client::key( $key = $title ) {

   file { "/usr/share/keyrings/$key":
      path => "/usr/share/keyrings/$key",
      ensure => file,
      mode => '0644',
      source => "puppet:///modules/apt/$key",
   }

   # apt-get update is done in the service class #
   exec { "apt-key add /usr/share/keyrings/$key":
      path => '/usr/bin:/usr/sbin:/bin',
      subscribe => File["/usr/share/keyrings/$key"],
      refreshonly => true,
   }
}
