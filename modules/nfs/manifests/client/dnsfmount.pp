class nfs::client::dnfsmount (
   $home_server = $nfs::client::home_server,
   $samba_domain = $nfs::client::samba_domain,
   $samba_share_share = $nfs::client::samba_share_share,
   $samba_users_group = $nfs::client::samba_users_group,
   $samba_common_mount_name = $nfs::client::samba_common_mount_name 
) inherits nfs::client {

   ##############
   # home mount #
   ##############

   file { '/dnfs':
      ensure => directory,
   }

   nfs::client::nfs4mount { '/dnfs':
      host => "${home_server}.${samba_domain}",
      share => '/',
      require => File['/dnfs'],
   }

   #################
   # use pam mount #
   #################

   pammount::mount { "/media/%(USER)/${samba_common_mount_name}" :
      path => "/dnfs/${samba_share_share}/%(GROUP)",
      options => "bind",
      sgrp => "${samba_users_group}",
   }

}
