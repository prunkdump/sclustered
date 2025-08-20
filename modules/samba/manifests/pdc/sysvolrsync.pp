class samba::pdc::sysvolrsync (
   $rsync_sysvol = false
) {

   $sysvolrsyncsrv_dns = $samba::pdc::sysvolrsyncsrv_dns
   $sysvolrsync_password = $samba::pdc::sysvolrsync_password
   $sysvol_path = $samba::pdc::sysvol_path
   $etc_path = $samba::pdc::etc_path

   ################
   # rsync export #
   ################
   rsync::server::export { 'sysvol':
      path => "${sysvol_path}/",
      password => $sysvolrsync_password,
   }    

   # check if we need to rsync sysvol #
   if $rsync_sysvol == true {

      rsync::replicate { 'sysvol':
         server => $sysvolrsyncsrv_dns,
         password => $sysvolrsync_password,
         src_files => ['/'],
         dest_path => "${sysvol_path}",
         minute => '0/15',
         randomize => '5m',
      }
   } 

   # else register as sysvol reference #
   else { 

      ############
      # register #
      ############
      samba::srvregister { "$sysvolrsyncsrv_dns":
        ensure => present,
      }
   }
}
