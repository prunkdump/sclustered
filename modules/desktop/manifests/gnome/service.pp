class desktop::gnome::service {

   service { 'lightdm':
      ensure => stopped,
      enable => false,
   }

   service { 'gdm':
      ensure => running,
      enable => true,
      #require => Service['lightdm'],
      subscribe => Class['desktop::service'],
   }
}
