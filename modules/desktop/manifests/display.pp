class desktop::display (
   $force_mirror = undef, 
   $disable_wayland = false
) {


   #####################
   # disable wayland ? #
   #####################
   if $force_mirror or $disable_wayland == true {
      $wayland_line = 'WaylandEnable=false'
   } else {
      $wayland_line = '#WaylandEnable=false'
   }

   # disable Wayland #
   file_line { 'gdm_disable_wayland':
      path => '/etc/gdm3/daemon.conf',
      line => "$wayland_line",
      match => 'WaylandEnable',
      ensure => present,
      multiple => false,
   }

 
   if $force_mirror { 

      # edid reader #
      package { 'read-edid':
         ensure => installed,
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

      exec { 'desktop_gdm_force_mirror':
         path => '/usr/bin:/usr/sbin:/bin',
         subscribe => [Package['read-edid'],File['desktop_gdm_force_mirror'],File['desktop_gdm_force_mirror_conf_file']],
         refreshonly => true,
      }

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
