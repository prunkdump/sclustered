class wifi (
   $interface = $wifi::params::interface,
   $disabled_interfaces = $wifi::params::disabled_interfaces,
   $ssid = $wifi::params::ssid,
   $psk = $wifi::params::psk
) inherits wifi::params {

   if $interface and $ssid and $psk {

      anchor { 'wifi::begin': } ->
      class { 'wifi::install': } ->
      class { 'wifi::config': } ~>
      class { 'wifi::postconfig': } ->
      anchor { 'wifi::end': }

   }  
}
