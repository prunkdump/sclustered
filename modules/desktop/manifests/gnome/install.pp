class desktop::gnome::install {

   # to disable some packages #
   #file { '/etc/apt/preferences.d/gnome.pref':
   #   ensure => present,
   #   source => 'puppet:///modules/desktop/gnome.pref',
   #   mode => '0644',
   #}

   # install gnome #

   # needed sometimes to correct a bug 
   #package { 'dbus':
   #   ensure => installed,
   #}

   package { 'lightdm':
      ensure => absent,
   }

   package { 'task-gnome-desktop':
      ensure => installed,
      #require => [File['/etc/apt/preferences.d/gnome.pref'],Package['dbus']],
   }

   # gnome extensions #
   package { 'gnome-shell-extensions':
      ensure => installed,
   }

   # add logout button extension #
   # now in repository #
   package { 'gnome-shell-extension-log-out-button':
      ensure => installed,
   }

   #file { '/usr/share/gnome-shell/extensions/LogOutButton@kyle.aims.ac.za':
   #   ensure => directory,
   #   mode => '0755',
   #   source => 'puppet:///modules/desktop/LogOutButton@kyle.aims.ac.za',
   #   recurse => remote,
   #   require => Package['task-gnome-desktop'],
   #}

}
