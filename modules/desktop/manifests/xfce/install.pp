class desktop::xfce::install {

   #package { 'gdm':
   #   ensure => absent,
   #}

   #  !!!BUG!!! in stretch #
   # dbus hang in task-xfce-desktop #
   # may not be necessary anymore 
   #package { 'dbus':
   #   ensure => installed,
   #}

   package { 'task-xfce-desktop':
      ensure => installed,
   #   require => Package['dbus'],
   }

}
