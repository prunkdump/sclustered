class samba::member::service {

   $adservice = $samba::member::adservice
   $disable_nss = $samba::member::disable_nss
   $disable_pam = $samba::member::disable_pam

   # stop samba ad services #
   service { $adservice:
      ensure => stopped,
      enable => false,
   }

   # does not use netbios #
   service { 'nmbd':
      ensure => stopped,
      enable => false,
      require => Service[$adservice],
   }

   # start samba service #
   service { 'smbd':
      ensure => running,
      enable => true,
      require => Service[$adservice],
   }

   # ntp #
   # switched to systemd-timesyncd
   #service { 'ntp':
   #   ensure => running,
   #   enable => true,
   #}

   # BUGGY
   # start winbind if needed #
   if $disable_nss == false or $disable_pam == false {
      service { 'winbind':
         ensure => running,
         enable => true,
         require => Service[$adservice,'nmbd','smbd'],
      }
   }
}
