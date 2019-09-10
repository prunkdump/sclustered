class desktop::gnome::service {

   # uninstalled in install.pp
   #
   #service { 'lightdm':
   #   ensure => stopped,
   #   enable => false,
   #}

   # !!! BUG gdm failed to restart !!! # 
   # refresh only when disable wayland #
   service { 'gdm':
      ensure => running,
      enable => true,
   #   subscribe => Class['desktop::service'],
   }
}
