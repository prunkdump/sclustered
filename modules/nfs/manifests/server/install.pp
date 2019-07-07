class nfs::server::install {

   ###########
   # package #
   ###########
   package { 'nfs-kernel-server':
      ensure => installed,
   }

   package { 'gssproxy':
      ensure => installed,
   }

}
