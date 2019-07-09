class dhcp::install {

   ############
   # packages #
   ############

   package { 'isc-dhcp-server':
      ensure => installed,
   }

}
