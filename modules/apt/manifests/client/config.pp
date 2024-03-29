define apt::client::config::pinning( $package = $title, $pin, $priority, $ensure = present) {

   file { "/etc/apt/preferences.d/${package}.pref":
      ensure => $ensure,
      content => template('apt/pinning.erb'),
      mode => '0644',
   }
}

define apt::client::config::pinning_p( $pinname = $title, $params ) {

   apt::client::config::pinning { "$pinname" :
      pin => $params[$pinname][0],
      priority => $params[$pinname][1],
      ensure => present,
   }
}


define apt::client::config::source( $sourcename = $title, $type = 'deb', $uri, $distribution = $apt::client::distribution, $components, $ensure = present) {

   file { "/etc/apt/sources.list.d/$sourcename":
      ensure => $ensure,
      content => template('apt/source.erb'),
      mode => '0644',
      require => Class['apt::client::audit'],
      notify => Class['apt::client::update'],
   }
}


class apt::client::config {

   $proxy_host = $apt::client::proxy_host
   $proxy_port = $apt::client::proxy_port
   $directs = $apt::client::directs
   $distribution = $apt::client::distribution
   $sources = $apt::client::sources
   $pinnings = $apt::client::pinnings
   $rep_keys = $apt::client::rep_keys

   ###############################
   # add the needed repositories #
   ###############################
   file { 'sources.list':
      path => '/etc/apt/sources.list',
      ensure => file,
      content => template('apt/sources.list.erb'),
      mode => '0644',
   }

   # allow suite change #
   file { '01allowreleasesuitechange':
      path => '/etc/apt/apt.conf.d/01allowreleasesuitechange',
      ensure => present,
      source => "puppet:///modules/apt/01allowreleasesuitechange",
      mode => '0644',
   }

   ################
   # apt pinnings #
   ################
   $pinnings_keys = keys($pinnings)
   apt::client::config::pinning_p { $pinnings_keys:
      params => $pinnings,
   }   

   #######################
   # intall the apt keys #
   #######################
   apt::client::key{ $rep_keys: }

   # check if apt proxy is used #
   if $proxy_host and $proxy_port {
      $proxy_file = 'present'
   } else {
      $proxy_file = 'absent'
   }
   
   file { '01proxy':
      path => '/etc/apt/apt.conf.d/01proxy',
      ensure => $proxy_file,
      content => template('apt/01proxy.erb'),
      mode => '0644',
   }
}
