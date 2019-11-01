class dhcp::params {

   include network
   include samba
   include puppet

   ########
   # main #
   ########
   $interfaces = $::samba::interfaces
   $network = $::network::null_address
   $netmask = $::network::netmask

   # params #
   if $::network::gateway {
      $routers = ["$::network::gateway"]
   } else {
      if $::network::http_proxy {
         $proxy_params = split($::network::http_proxy, ':')
         $routers = ["${proxy_params[0]}"]
      } else {
         $routers = ["${::network::effective_gateway}"]
      }
   }

   $default_lease_time = 1814400
   $max_lease_time = 3628800

   $domain_name = $::samba::domain
   $domain_name_servers = ["${::hostname}"]

   #only puppet ca master can make FAI
   $pxe_server = $::puppet::casrv_dns
   $pxe_filename = $::puppet::fai_pxe_finename
   $ntp_servers = ["${::hostname}"]
   $options = {}

   ###########
   # default #
   ###########
   $default_network = undef
   $default_netmask = undef
   $default_range = undef
   $default_options = {}

   ###################
   # hosts and pools #
   ###################
   $fixed_hosts = {}
   $pool_hosts = {}
   $pools = {}
   $classes = {}
   $fai_hosts = $::puppet::fai_hosts
   
}
