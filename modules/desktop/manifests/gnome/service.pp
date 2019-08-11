class desktop::gnome::service {

   # uninstalled in install.pp
   #
   #service { 'lightdm':
   #   ensure => stopped,
   #   enable => false,
   #}

   service { 'gdm':
      ensure => running,
      enable => true,
      subscribe => Class['desktop::service'],
   }
}
