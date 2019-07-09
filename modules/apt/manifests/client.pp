class apt::client (
   $proxy_host = $apt::srv_dns,
   $proxy_port = $apt::port,
   $directs = $apt::directs,
   $distribution = $apt::distribution,
   $sources = $apt::sources,
   $sources_additional = $apt::sources_additional,
   $pinnings = $apt::pinnings,
   $rep_keys = $apt::keys,
   $rep_keys_additional = $apt::keys_additional,
   $autoupdates = $apt::autoupdates,
   $autoupdate_blacklist = $apt::autoupdate_blacklist
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
         require => Class['apt::client::update'],
         before => Anchor['apt::client::end'],
      }
   }
   anchor { 'apt::client::end': }
}
