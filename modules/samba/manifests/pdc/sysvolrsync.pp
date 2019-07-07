class samba::pdc::sysvolrsync {

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

   ############
   # register #
   ############
   samba::srvregister { "$sysvolrsyncsrv_dns":
      ensure => present,
   }
}
