class apt::server::install {

   ###########
   # package #
   ###########

   package { 'apt-cacher-ng':
      ensure => installed,
   }

}
