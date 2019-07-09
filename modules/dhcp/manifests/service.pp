class dhcp::service {

   ###########
   # service #
   ###########

   service { 'isc-dhcp-server':
      ensure => running,
      enable => true,
   }

}
