class wine::server (
   $serverpath = $wine::serverpath,
   $servergroup = $wine::servergroup,
   $winersync_password = $wine::winersync_password  
) inherits wine {

   #############################################
   # create a wine admin group with s4groupadd #
   # and set the wine::servergroup value       #
   #############################################
   if $serverpath and $servergroup {

      #####################
      # create export dir #
      #####################
      exec { 'make_wine_export_dir':
         command => "mkdir -p $serverpath",
         path => '/usr/bin:/usr/sbin:/bin',
         creates => "$serverpath",
      }

      file { "$serverpath":
         ensure => directory,
         owner => 'root',
         group => "$servergroup",
         mode => '0775',
         require => Exec['make_wine_export_dir'],
      }
 
      ################
      # serve by nfs #
      ################
      include nfs::server

      # serve as /wine #
      nfs::server::nfs4export { "$serverpath":
         share => '/wine',
      }

      ##################
      # serve as rsync #
      ##################
      rsync::server::export { 'wine':
         path => "${serverpath}/",
         password => $winersync_password,
      }
   }
}
