class desktop::gnome (
   $dash_apps = $desktop::gnome::params::dash_apps,
   $extensions = $desktop::gnome::params::extensions,
   $idle_time = $desktop::gnome::params::idle_time,
   $autologout_time = $desktop::gnome::params::autologout_time,
   $http_proxy = $desktop::gnome::params::http_proxy,
   $https_proxy = $desktop::gnome::params::https_proxy,
   $force_mirror = $desktop::gnome::params::force_mirror,
   $disable_wayland = $desktop::gnome::params::disable_wayland
) inherits desktop::gnome::params {

   anchor { 'desktop::gnome::begin': } ->
   class { 'desktop::gnome::install': } ->
   class { 'desktop::gnome::config-dconf': } ~>
   class { 'desktop::gnome::dconf': } ->
   class { 'desktop::gnome::config-gdm': } ~>
   class { 'desktop::gnome::service': } ->
   class { 'desktop::gnome::display': } ->
   anchor { 'desktop::gnome::end': }
   
}
