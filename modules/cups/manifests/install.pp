class cups::install {

   ###########
   # package #
   ###########

   package { 'cups':
      ensure => installed,
   }

   # script to migrate printers #
   file { 'cups-server-migrate':
      path => '/usr/bin/cups-server-migrate',
      ensure => file,
      source => 'puppet:///modules/cups/cups-server-migrate',
      mode => '0755',
   }
}
