class desktop::gnome::display {

   $force_mirror = $desktop::gnome::force_mirror

   ################
   # force mirror #
   ################

   # restart gdm is not needed #
 
   if $force_mirror { 

      # edid reader #
      package { 'read-edid':
         ensure => installed,
      }

      file { '/usr/bin/xrandr-verbose':
         ensure => file,
         mode => '0755',
         source => 'puppet:///modules/desktop/xrandr-verbose',
      }

      file { 'desktop_gdm_force_mirror':
         path => '/usr/sbin/desktop_gdm_force_mirror',
         ensure => file,
         content => template('desktop/desktop_gdm_force_mirror.erb'),
         mode => '0744',
      }

      # used to signal execution of force mirror #
      file { 'desktop_gdm_force_mirror_conf_file':
         path => '/var/lib/gdm3/.config/monitors.xml.def',
         ensure => file,
         content => "$force_mirror",
         mode => '0644',
      }

      # exec desktop_gdm_force mirror when script change or screen parameter change #
      exec { 'desktop_gdm_force_mirror_refresh':
         command => 'desktop_gdm_force_mirror',
         path => '/usr/bin:/usr/sbin:/bin',
         subscribe => [Package['read-edid'],File['/usr/bin/xrandr-verbose','desktop_gdm_force_mirror','desktop_gdm_force_mirror_conf_file']],
         refreshonly => true,
      }

      # exec desktop_gdm_force_mirror if setup is not successfull #
      exec { 'desktop_gdm_force_mirror_conf_file':
         command => 'desktop_gdm_force_mirror',
         path => '/usr/bin:/usr/sbin:/bin',
         creates => '/var/lib/gdm3/.config/monitors.xml',
         require => Exec['desktop_gdm_force_mirror_refresh'],
      }
      
      # exec /var/lib/gdm3/.config/monitors.xml.sh at logon #
      file { '/etc/xdg/autostart/setupxorg.desktop':
         ensure => file,
         content => "[Desktop Entry]\nType=Application\nName=avertlogon\nExec=/var/lib/gdm3/.config/monitors.xml.sh",
         mode => '0644',
      }
     

   } else {

      file { '/var/lib/gdm3/.config/monitors.xml':
         ensure => absent;
      }

      file { '/var/lib/gdm3/.config/monitors.xml.sh':
         ensure => absent;
      }

      file { '/var/lib/gdm3/.config/monitors.xml.def':
         ensure => absent;
      }

      file { '/etc/xdg/autostart/setupxorg.desktop':
         ensure => absent;
      }
   }
}
