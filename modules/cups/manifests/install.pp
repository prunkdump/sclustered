class cups::install {

   ###########
   # package #
   ###########

   package { 'cups':
      ensure => installed,
   }

}
