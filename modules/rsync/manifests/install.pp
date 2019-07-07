class rsync::install {

   ###########
   # package #
   ###########

   package { 'rsync':
      ensure => installed,
   }

   # nedded to store password files #
   file { '/var/lib/rsync':
      ensure => directory,
   }
}
