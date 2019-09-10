class desktop::gnome::config-gdm {

   $force_mirror = $desktop::gnome::force_mirror
   $disable_wayland = $desktop::gnome::disable_wayland


   #####################
   # disable user list #
   #####################
   file_line { "gdm_disable_user_list":
      path => '/etc/gdm3/greeter.dconf-defaults',
      line => 'disable-user-list=true',
      match => 'disable-user-list',
      ensure => present,
      multiple => false,
   }


   #############################
   # disable wayland if needed #
   #############################
   if $force_mirror or $disable_wayland == true {
      $wayland_line = 'WaylandEnable=false'
   } else {
      $wayland_line = '#WaylandEnable=false'
   }

   file_line { 'gdm_disable_wayland':
      path => '/etc/gdm3/daemon.conf',
      line => "$wayland_line",
      match => 'WaylandEnable',
      ensure => present,
      multiple => false,
   }
}
