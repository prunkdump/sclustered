class rsync::server::service {

   service { 'rsync':
      ensure => running,
      enable => true,
   }

}
