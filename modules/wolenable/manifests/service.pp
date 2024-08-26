class wolenable::service {

   service { 'wolenable':
      enable => true,
   }

   exec { 'wolenable':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      subscribe => Service['wolenable'],
      refreshonly => true,
   }
}
