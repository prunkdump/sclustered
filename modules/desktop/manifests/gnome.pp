class desktop::gnome (
   $dash_apps = $desktop::gnome::params::dash_apps,
   $extensions = $desktop::gnome::params::extensions,
   $idle_time = $desktop::gnome::params::idle_time,
   $autologout_time = $desktop::gnome::params::autologout_time,
   $http_proxy = $desktop::gnome::params::http_proxy,
   $https_proxy = $desktop::gnome::params::https_proxy
) inherits desktop::gnome::params {

   anchor { 'desktop::gnome::begin': } ->
   class { 'desktop::gnome::install': } ->
   class { 'desktop::gnome::config': } ~>
   class { 'desktop::gnome::dconf': } ~>
   class { 'desktop::gnome::service': } ->
   anchor { 'desktop::gnome::end': }
   
}
