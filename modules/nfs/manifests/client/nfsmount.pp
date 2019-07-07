define nfs::client::nfsmount (
   $path = $title,
   $host,
   $share,
   $options = undef,
   $options_additional = []
) {

   include nfs::client 

   $mount_options = $nfs::client::mount_options

   if $options {
      $global_options = concat($options, $options_additional)
   } else {
      $global_options = concat($mount_options, $options_additional)
   }

   $global_options_str = join($global_options, ',')


   # simply mount the nfs device #
   mount { "$path":
      device => "${host}:${share}",
      fstype => nfs,
      ensure => mounted,
      options => $global_options_str,
      remounts => false,
   }

}
