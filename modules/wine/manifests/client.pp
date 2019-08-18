class wine::client (
   $winesrv_dns = $wine::winesrv_dns,
   $winersync_password = $wine::winersync_password,
   $apps = $wine::apps,
   $enabled = $wine::enabled,
   $associate = $wine::associate
) inherits wine {

   anchor { 'wine::client::begin': }->
   class { 'wine::client::install': }->
   class { 'wine::client::config': }~>
   class { 'wine::client::update': }->
   anchor { 'wine::client::end': }

}

