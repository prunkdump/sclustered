class wine::client::config {

   $winesrv_dns = $wine::client::winesrv_dns
   $winersync_password = $wine::client::winersync_password
   $apps = $wine::client::apps
   $enabled = $wine::client::enabled
   $associate = $wine::client::associate

   if $associate == true and (! empty($apps) or $enabled == true) {
      file { '/usr/share/applications/wine.desktop':
         ensure => present,
         source => 'file:/usr/share/doc/wine/examples/wine.desktop',
         mode => '0644',
      }
   } else {
      file { '/usr/share/applications/wine.desktop':
         ensure => absent,
      }
   }

   if ! empty($apps) {

      #######################################
      # create desktop and icons files from #
      # nfs share                           #
      #######################################
      $prefixed_apps = prefix($apps, 'file:/dnfs/wine/')
      $apps_applications_sources = suffix($prefixed_apps, '/applications')
      $apps_icons_sources = suffix($prefixed_apps, '/icons')
 
      file { "app_wine_application_files" :
         path => '/usr/share/applications/wine',
         ensure => directory,
         source => $apps_applications_sources,
         sourceselect => all,
         recurse => true,
         purge => true,
      }

      file { "app_wine_icon_files" :
         path => '/usr/share/icons',
         ensure => directory,
         source => $apps_icons_sources,
         sourceselect => all,
         recurse => remote,
      }

      ############################
      # rsync the full wine tree #
      ############################
      rsync::replicate { 'wine':
         server => $winesrv_dns,
         password => $winersync_password,
         src_files => ['/'],
         dest_path => '/wine',
         minute => '*/15',
      }
   }

   else {

      file { "app_wine_application_files" :
         path => '/usr/share/applications/wine',
         ensure => directory,
         recurse => true,
         purge => true,
      }
   }
}
