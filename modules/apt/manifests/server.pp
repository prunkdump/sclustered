class apt::server (
   $http_proxy = $apt::http_proxy,
   $https_proxy = $apt::https_proxy,
   $remaps = $apt::remaps,
   $debian_reps = $apt::debian_reps,
   $autoupdates = $apt::autoupdates,
   $autoupdate_blacklist = $apt::autoupdate_blacklist,
   $autoupdate_times = $apt::autoupdate_times,
   $autoupdate_reboot = $apt::autoupdate_reboot
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
         autoupdate_times => $autoupdate_times,
         autoupdate_reboot => $autoupdate_reboot,
         require => Class['apt::server::service'],
         before => Anchor['apt::server::end'],
      }
   }
   anchor { 'apt::server::end': }
}   

   
