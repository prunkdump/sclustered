class network (
   $slashform  = $network::params::slashform,
   $gateway = $network::params::gateway,
   $http_proxy = $network::params::http_proxy,
   $https_proxy = $network::params::http_proxy
) inherits network::params {

   #######################
   # compute public vars #
   #######################

   # get params #
   $network_params = split($slashform, '/')
   $network_base = $network_params[0]
   $network_base_split = split($network_base, '[.]')
   $network_intmask  = $network_params[1] 

   if $network_intmask != '8' and  $network_intmask != '16' and  $network_intmask != '24' {
      fail("Currently only 8, 16, 24 bit netmask are supported !")
   }

   # compute netmask #
   $netmask = $network_intmask? {
      '8' => '255.255.255.0',
      '16' => '255.255.0.0',
      '24' => '255.0.0.0'
   }

   # compute broadcast #
   $broadcast = $network_intmask? {
      '8' => "${network_base_split[0]}.${network_base_split[1]}.${network_base_split[2]}.255",
      '16' => "${network_base_split[0]}.${network_base_split[1]}.255.255",
      '24' => "${network_base_split[0]}.255.255.255"
   }

   # compute reverse zone #
   $reverse_zone = $network_intmask? {
      '8' => "${network_base_split[2]}.${network_base_split[1]}.${network_base_split[0]}.in-addr.arpa",
      '16' => "${network_base_split[1]}.${network_base_split[0]}.in-addr.arpa",
      '24' => "${network_base_split[0]}.in-addr.arpa",
   } 

   # compute star form #
   $starform = $network_intmask? {
      '8' => "${network_base_split[0]}.${network_base_split[1]}.${network_base_split[2]}.*",
      '16' => "${network_base_split[0]}.${network_base_split[1]}.*.*",
      '24' => "${network_base_split[0]}.*.*.*"
   }

   # compute specials addresses #
   $first_address = "${network_base_split[0]}.${network_base_split[1]}.${network_base_split[2]}.1"
   $null_address = "${network_base_split[0]}.${network_base_split[1]}.${network_base_split[2]}.0"


   # compute gateway #
   $effective_gateway = $gateway? {
      undef => $first_address,
      default => $gateway
   }


   ##################
   # configure wget #
   ##################
   anchor { 'network::wget::begin': } ->  
   class { 'network::wget': } ->
   anchor { 'network::wget::end': }
}
