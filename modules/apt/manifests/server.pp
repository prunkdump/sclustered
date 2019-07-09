class apt::server (
   $http_proxy = $apt::http_proxy,
   $https_proxy = $apt::https_proxy,
   $remaps = $apt::remaps,
   $debian_reps = $apt::debian_reps,
   $autoupdates = $apt::autoupdates,
   $autoupdate_blacklist = $apt::autoupdate_blacklist
) inherits apt {

   # common vars  #
   $port = $apt::port
   $srv_dns = $apt::srv_dns   

   ##############
   # apt server #
   ##############
   anchor { 'apt::server::begin': } ->
   class { 'apt::server::install': } ->
   class { 'apt::server::config': } ~>
   class { 'apt::server::service': }
   if ! empty($autoupdates) {
      class{ 'apt::autoupdate':
         autoupdates => $autoupdates,
         autoupdate_blacklist => $autoupdate_blacklist,
         require => Class['apt::server::service'],
         before => Anchor['apt::server::end'],
      }
   }
   anchor { 'apt::server::end': }
}   

   
