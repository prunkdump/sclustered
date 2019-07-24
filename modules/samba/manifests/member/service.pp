class samba::member::service {

   $adservice = $samba::member::adservice
   $disable_nss = $samba::member::disable_nss
   $disable_pam = $samba::member::disable_pam

   # stop samba ad services #
   service { $adservice:
      ensure => stopped,
      enable => false,
   }

   # start standard samba services #
   service { ['nmbd','smbd']:
      ensure => running,
      enable => true,
      require => Service[$adservice],
   }

   # ntp #
   service { 'ntp':
      ensure => running,
      enable => true,
   }

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
