class samba::dcservice (
   $adservice,
   $disable_nss,
   $disable_pam
) {

   # stop standard samba services #
   # on dc, winbind is not needed #
   service { ['nmbd','smbd','winbind']:
      ensure => stopped,
      enable => false,
   }

   # start samba ad services #
   service { $adservice:
      ensure => running,
      enable => true,
      require => Service['nmbd','smbd','winbind'],
   }

   exec { 'wait_for_winbind':
      path => '/usr/bin:/usr/sbin:/bin',
      command => 'while ! wbinfo --group-info=domain\ admins > /dev/null 2>&1; do sleep 1; done',
      subscribe => Service["$adservice"],
      refreshonly => true,
      provider => 'shell',
   }

   # ntp #
   service { 'ntp':
      ensure => running,
      enable => true,
   }
}
