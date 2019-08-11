class desktop::xfce::service {

   # uninstalled in install.pp #
   #
   #service { 'gdm':
   #    ensure => stopped,
   #    enable => false,
   # }

   service { 'lightdm':
      ensure => running,
      enable => true,
      subscribe => Class['desktop::service'],
   }

}
