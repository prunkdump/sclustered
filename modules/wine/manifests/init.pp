class wine (
   $serverpath = $wine::params::serverpath,
   $servergroup = $wine::params::servergroup,
   $winesrv_dns = $wine::params::winesrv_dns,
   $winersync_password = $wine::params::winersync_password,
   $apps = $wine::params::apps,
   $enabled = $wine::params::enabled,
   $associate = $wine::params::associate
) inherits wine::params {

   # use wine::client or wine::server

}
