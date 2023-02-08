class cups::postconfig {
   
   $disable_lpupdate = $cups::disable_lpupdate
   $printers = $cups::printers
   $default_printer = $cups::default_printer
   $default_printserver = $cups::default_printserver

   if $disable_lpupdate == false {
      ####################
      # network printers #
      ####################

      # script to update printers #
      file { 'lpupdate':
         path => '/usr/bin/lpupdate',
         ensure => file,
         source => 'puppet:///modules/cups/lpupdate',
         mode => '0744',
      }

      # file containing printers #
      file { 'printers_list.conf':
         path => '/etc/cups/printers_list.conf',
         ensure => file,
         content => template('cups/printers_list.conf.erb'),
         mode => '0644',
      }

      exec { 'lpupdate':
         path => '/usr/bin:/usr/sbin:/bin',
         refreshonly => true,
         subscribe => File['lpupdate','printers_list.conf'],
      }

      # bug : sometimes cups disable printers #
      # run lpupdate every hours #
      file { '/etc/cron.hourly/lpupdate':
         ensure => 'link',
         target => '/usr/bin/lpupdate',
         require => File['lpupdate','printers_list.conf'],
      } 
   }
}

