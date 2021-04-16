class cups (
   $disable_lpupdate = $cups::params::disable_lpupdate,
   $web_access = $cups::params::web_access,
   $printers = $cups::params::printers,
   $default_printer = $cups::params::default_printer,
   $default_printserver = $cups::params::default_printserver
) inherits cups::params {

   anchor { 'cups::begin': } ->
   class { 'cups::install': } ->
   class { 'cups::config': } ~>
   class { 'cups::service': } ~>
   class { 'cups::postconfig': } ->
   anchor { 'cups::end': }
}
   

