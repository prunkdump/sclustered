class cups::service {

   ###########
   # service #
   ###########

   service { "cups":
      ensure => running,
      enable => true,
   }

   # disable browsing service #
   service { 'cups-browsed':
      ensure => stopped,
      enable => false,
   }

}
