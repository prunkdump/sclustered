class desktop::gnome::service {

   # uninstalled in install.pp
   #
   #service { 'lightdm':
   #   ensure => stopped,
   #   enable => false,
   #}

   # !!! BUG gdm failed to restart !!! # 
   service { 'gdm':
      ensure => running,
      enable => true,
   #   subscribe => Class['desktop::service'],
   }
}
