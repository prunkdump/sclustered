class apt::server::config {

   $http_proxy = $apt::server::http_proxy
   $https_proxy = $apt::server::https_proxy
   $remaps = $apt::server::remaps
   $debian_reps = $apt::server::debian_reps
   $port = $apt::server::port
   $srv_dns = $apt::server::srv_dns

   ##############
   # check data #
   ##############

   # check proxy #
   # only one http OR https proxy can be used #
   if $http_proxy or $https_proxy {
      $http_proxy_status = present
      if $http_proxy {
         $http_proxy_target = "http://$http_proxy"
      } else {
         $http_proxy_target = "https://$https_proxy"
      }
   } else {
      $http_proxy_status = absent
   }

   ##########
   # config #
   ##########

   # server port option #
   file_option { 'acng_port':
      path => '/etc/apt-cacher-ng/acng.conf',
      option => 'Port',
      value => "$port",
      separator => ': ',
      multiple => false,
      ensure => present,
   }

   # http proxy option #
   file_option { 'acng_http_proxy':
      path => '/etc/apt-cacher-ng/acng.conf',
      option => 'Proxy',
      value => "$http_proxy_target",
      separator => ': ',
      multiple => false,
      ensure => $http_proxy_status,
   }

   # backends configuration #
   file_option { 'acng_backend_debian':
      path => '/etc/apt-cacher-ng/acng.conf',
      option => "Remap-debrep",
      value => 'file:deb_mirror*.gz /debian ; file:backends_debian # Debian Archives',
      separator => ': ',
      multiple => false,
      ensure => present,
   }

   file { 'acng_backends_debian':
      path => '/etc/apt-cacher-ng/backends_debian',
      ensure => file,
      content => template('apt/backends_debian.erb'),
      mode => '0644',
   }

   # remaps configuration #
   $remap_list = keys($remaps)
   apt::server::remap { $remap_list:
      targets => $remaps,
   }

}   

   
