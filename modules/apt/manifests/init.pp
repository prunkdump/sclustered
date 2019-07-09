class apt (
   $port = $apt::params::port,
   $http_proxy = $apt::params::http_proxy,
   $https_proxy = $apt::params::https_proxy,
   $srv_dns = $apt::params::srv_dns,
   $directs = $apt::params::directs,
   $remaps = $apt::params::remaps,
   $debian_reps = $apt::params::debian_reps,
   $distribution = $apt::params::distribution,
   $sources = $apt::params::sources,
   $sources_additional = $apt::params::sources_additional,
   $pinnings = $apt::params::pinnings,
   $keys = $apt::params::keys,
   $keys_additional = $apt::params::keys_additional,
   $autoupdates = $apt::params::autoupdates,
   $autoupdate_blacklist = $apt::params::autoupdate_blacklist
) inherits apt::params {



}


