class cups::install {

   ###########
   # package #
   ###########

   package { 'cups':
      ensure => installed,
   }

   # script to migrate printers #
   file { 'cups-migrate':
      path => '/usr/bin/cups-migrate',
      ensure => file,
      source => 'puppet:///modules/cups/cups-migrate',
      mode => '0755',
   }
}
