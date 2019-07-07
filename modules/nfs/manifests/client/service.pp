class nfs::client::service {

   $enable_cachefilesd = $nfs::client::enable_cachefilesd

   ############
   # services #
   ############

   # common nfs service #
   service { 'rpc-gssd':
      ensure    => running,
      enable    => true,
   }

   # BUGGY SERVICE, expect is was launched
   if $enable_cachefilesd == true {
      service { 'cachefilesd':
         ensure    => running,
         enable    => true,
      }
   }

}
