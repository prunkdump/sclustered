class apt::client (
   $proxy_host = $apt::srv_dns,
   $proxy_port = $apt::port,
   $directs = $apt::directs,
   $distribution = $apt::distribution,
   $sources = $apt::sources,
   $pinnings = $apt::pinnings,
   $rep_keys = $apt::keys,
   $autoupdates = $apt::autoupdates,
   $autoupdate_blacklist = $apt::autoupdate_blacklist,
   $autoupdate_times = $apt::autoupdate_times,
   $autoupdate_reboot = $apt::autoupdate_reboot
) inherits apt {

   ##############
   # apt client #
   ##############
   anchor { 'apt::client::begin': } ->
   class { 'apt::client::audit': } ->
   # nothing to install
   class { 'apt::client::config': } ~>
   class { 'apt::client::update': }
   if ! empty($autoupdates) {
      class{ 'apt::autoupdate':
         autoupdates => $autoupdates,
         autoupdate_blacklist => $autoupdate_blacklist,
         autoupdate_times => $autoupdate_times,
         autoupdate_reboot => $autoupdate_reboot,
         require => Class['apt::client::update'],
         before => Anchor['apt::client::end'],
      }
   }
   anchor { 'apt::client::end': }
}
