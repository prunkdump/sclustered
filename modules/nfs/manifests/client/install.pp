class nfs::client::install {

   $enable_cachefilesd = $nfs::client::enable_cachefilesd 

   #################
   # nfs4 packages #
   #################
   if $enable_cachefilesd == true {
      package { 'cachefilesd':
         ensure => installed,
      }
   }

}
