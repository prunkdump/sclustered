class dhcp (
   $interfaces = $dhcp::params::interfaces,
   $network = $dhcp::params::network,
   $netmask = $dhcp::params::netmask,
   $routers = $dhcp::params::routers,
   $default_lease_time = $dhcp::params::default_lease_time,
   $max_lease_time = $dhcp::params::max_lease_time,
   $domain_name = $dhcp::params::domain_name,
   $domain_name_servers = $dhcp::params::domain_name_servers,
   $pxe_server = $dhcp::params::pxe_server,
   $pxe_filename = $dhcp::params::pxe_filename,
   $ntp_servers = $dhcp::params::ntp_servers,
   $options = $dhcp::params::options,
   $default_network = $dhcp::params::default_network,
   $default_netmask = $dhcp::params::default_netmask,
   $default_range = $dhcp::params::default_range,
   $default_options = $dhcp::params::default_options,
   $fixed_hosts = $dhcp::params::fixed_hosts,
   $pool_hosts = $dhcp::params::pool_hosts,
   $pools = $dhcp::params::pools,
   $classes = $dhcp::params::classes,
   $fai_hosts = $dhcp::params::fai_hosts
) inherits dhcp::params {

   if (! empty($pools)) and (! ($default_network and $default_netmask)) and (! $default_range) {
      fail("If you use pools you need to set a default network or range for unknown clients !")
   }

   ########
   # dhcp #
   ########
   anchor { 'dhcp::begin': } ->
   class { 'dhcp::install': } ->
   class { 'dhcp::config': } ~>
   class { 'dhcp::service': } ->
   anchor { 'dhcp::end': }
}
