class desktop::gnome::configdconf {

   $dash_apps = $desktop::gnome::dash_apps
   $extensions = $desktop::gnome::extensions
   $idle_time = $desktop::gnome::idle_time 
   $autologout_time = $desktop::gnome::autologout_time
   $http_proxy = $desktop::gnome::http_proxy
   $https_proxy = $desktop::gnome::https_proxy


   if( $http_proxy ){
      $http_proxy_params = split($http_proxy,':')
      $http_proxy_host = $http_proxy_params[0]
      $http_proxy_port = $http_proxy_params[1]
   }
   if( $https_proxy ){
      $https_proxy_params = split($https_proxy,':')
      $https_proxy_host = $https_proxy_params[0]
      $https_proxy_port = $https_proxy_params[1]
   }


   ######################################
   # set as default desktop environment #
   ######################################


   #############################
   # default and lock settings #
   #############################
   file { ['/etc/dconf','/etc/dconf/profile',
           '/etc/dconf/db','/etc/dconf/db/userbaseconf.d','/etc/dconf/db/userbaseconf.d/locks']:
      ensure => directory,
   }

   file { '/etc/dconf/profile/user':
      path => '/etc/dconf/profile/user',
      ensure => file,
      mode => '0644',
      source => 'puppet:///modules/desktop/user',
      require => File['/etc/dconf/profile'],
   }

   # logout #
   if $autologout_time {
      $autologout_status = present
   }
   else {
      $autologout_status = absent
   }

   file { '00_autologout.key':
      path => '/etc/dconf/db/userbaseconf.d/00_autologout.key',
      ensure => $autologout_status,
      mode => '0644',
      content => template('desktop/00_autologout.key.erb'),
      require => File['/etc/dconf/db/userbaseconf.d'],
   }

   # default shell : dash and extensions #
   file { '01_shell.key':
      path => '/etc/dconf/db/userbaseconf.d/01_shell.key.erb',
      ensure => file,
      mode => '0644',
      content => template('desktop/01_shell.key.erb'),
      require => File['/etc/dconf/db/userbaseconf.d'],
   }

   # disable update dialog #
   file { '02_updates.key':
      path => '/etc/dconf/db/userbaseconf.d/02_updates.key',
      ensure => file,
      mode => '0644',
      source => 'puppet:///modules/desktop/02_updates.key',
      require => File['/etc/dconf/db/userbaseconf.d'],
   }

   # idle time #
   file { '02_idle_time.key':
      path => '/etc/dconf/db/userbaseconf.d/02_idle_time.key',
      ensure => file,
      mode => '0644',
      content => template('desktop/02_idle_time.key.erb'),
      require => File['/etc/dconf/db/userbaseconf.d'],
   }

   # proxy #
   if( $http_proxy or $https_proxy ) {
      
      file { '03_proxy.key':
         path => '/etc/dconf/db/userbaseconf.d/03_proxy.key',
         ensure => file,
         mode => '0644',
         content => template('desktop/03_proxy.key.erb'),
         require => File['/etc/dconf/db/userbaseconf.d'],
      }
   }
   else {

      file { '03_proxy.key':
         path => '/etc/dconf/db/userbaseconf.d/03_proxy.key',
         ensure => absent,
      }
   }

   # numlock and event sound #
   file { '04_peripherals.key':
      path => '/etc/dconf/db/userbaseconf.d/04_peripherals.key',
      ensure => file,
      mode => '0644',
      source => 'puppet:///modules/desktop/04_peripherals.key',
      require => File['/etc/dconf/db/userbaseconf.d'],
   }

   # lock it #
   file { 'userbaseconf.lock':
      path => '/etc/dconf/db/userbaseconf.d/locks/userbaseconf.lock',
      ensure => file,
      mode => '0644',
      source => 'puppet:///modules/desktop/userbaseconf.lock',
   }

}
