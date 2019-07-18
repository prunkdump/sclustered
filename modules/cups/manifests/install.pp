class cups::install {

   $disable_lpupdate = $cups::disable_lpupdate

   ###########
   # package #
   ###########

   package { 'cups':
      ensure => installed,
   }

   if $disable_lpupdate == false {

      # script to update printers #
      file { 'lpupdate':
         path => '/usr/bin/lpupdate',
         ensure => file,
         source => 'puppet:///modules/cups/lpupdate',
         mode => '0744',
      }
   }
}
