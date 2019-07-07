# !! you must unsure that $path is created !! #
define nfs::server::nfsexport (
   $path = $title,
   $options = undef,
   $options_additional = []
) {

   include nfs::server
   $export_options = $nfs::server::export_options 
   $network = $nfs::server::network

   if $options {
      $global_options = concat($options, $options_additional)
   } else {
      $global_options = concat($export_options, $options_additional)
   }

   $global_options_str = join($global_options, ',')


   # add to export directly #
   concat::fragment { "nfs_nfs_${path}":
      target => '/etc/exports',
      content => "${path}               ${network}($global_options_str)\n",
      order => '30',
   }
}
   
      
   
   
