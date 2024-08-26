class network::wget {

   $http_proxy = $network::http_proxy
   $https_proxy = $network::https_proxy

   ##############
   # check data #
   ##############

   # check if proxy need to be activated #
   if $http_proxy or $https_proxy {
      $use_proxy = "on"
   } else {
      $use_proxy = "off"
   }

   # check if we need to set option #
   if $http_proxy {
      $http_proxy_status = present
   } else {
      $http_proxy_status = absent
   }

   if $https_proxy {
      $https_proxy_status = present
   } else {
      $https_proxy_status = absent
   }

   #############
   #  package  #
   #############

   package { 'wget':
      ensure => installed,
   } 

   #################
   # configuration #
   #################

   # http_proxy option #
   file_option { 'wget_http_proxy':
      require => Package['wget'],
      path => '/etc/wgetrc',
      option => 'http_proxy',
      value => "http://$http_proxy/",
      multiple => false,
      ensure => $http_proxy_status,
   }

   # https_proxy option #
   file_option { 'wget_https_proxy':
      require => Package['wget'],
      path => '/etc/wgetrc',
      option => 'https_proxy',
      value => "http://$https_proxy/",
      multiple => false,
      ensure => $https_proxy_status,
   }

   # use_proxy option #
   file_option { 'wget_use_proxy':
      require => Package['wget'],
      path => '/etc/wgetrc',
      option => 'use_proxy',
      value => "$use_proxy",
      multiple => false,
      ensure => present,
   }

}
