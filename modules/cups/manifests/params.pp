class cups::params {

   include network

   $disable_lpupdate = false
   $web_access = $::network::starform
   $printers = {}
   $default_printer = undef

}
