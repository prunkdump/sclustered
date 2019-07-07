class nfs::server::service {

   ###########
   # service #
   ###########
   service { 'rpc-svcgssd':
      ensure  => stopped,
      enable  => false,
   }

   service { 'gssproxy':
      ensure  => running,
      enable  => true,
      require => Service['rpc-svcgssd'],
   }

   service { 'nfs-kernel-server':
      ensure => running,
      enable => true,
      require => [Service['rpc-svcgssd'], Service['gssproxy']],
   }
}
