class dhcp::service {

   $interfaces = $dhcp::interfaces

   ###########
   # service #
   ###########

   # don't run if no other interfaces than lo #
   if (! $interfaces) or ($interfaces == "") or (size($interfaces) == 0) or (size($interfaces) == 1 and $interfaces[0] == "lo") {
      service { 'isc-dhcp-server':
        ensure => stopped,
        enable => false,
      }

   } else {

      service { 'isc-dhcp-server':
         ensure => running,
         enable => true,
      }
   }
}
