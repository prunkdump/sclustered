# !! you must unsure that $path is created !! #
define nfs::server::nfs4export (
   $path = $title,
   $share,
   $options = undef,
   $options_additional = []
) {

   include nfs::server
   $export_options = $nfs::server::export_options 
   $nfs4_export_options = $nfs::server::nfs4_export_options
   $root_path = $nfs::server::root_path
   $network = $nfs::server::network

   if $options {
      $global_options = concat($options, $options_additional)
   } else {
      $global_options_tmp = concat($nfs4_export_options, $export_options)
      $global_options = concat($global_options_tmp, $options_additional)
   }

   $global_options_str = join($global_options, ',')

   # create the shared dir inside nfs4 root #
   exec { "mkdir -p ${root_path}${share}":
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "${root_path}${share}",
   }

   # bind mount inside nfs4 root #
   mount { "${root_path}${share}":
      ensure => mounted,
      device => $path,
      fstype => 'none',
      options => 'rw,bind,private',
      require => Exec["mkdir -p ${root_path}${share}"],
   }

   # add to export #
   concat::fragment { "export_nfs4_$share":
      target => '/etc/exports',
      content => "${root_path}${share}               ${network}(${global_options_str})\n",
      order => '20',
   }
}
   
      
   
   
