class desktop::xfce::service {

  service { 'gdm':
      ensure => stopped,
      enable => false,
   }

   service { 'lightdm':
      ensure => running,
      enable => true,
      subscribe => Class['desktop::service'],
   }

}
