class apt::server::service {

   $srv_dns = $apt::server::srv_dns

   ###########
   # service #
   ###########

   service { 'apt-cacher-ng':
      ensure    => running,
      enable    => true,
   }

   #####################
   # samba registering #
   #####################
   samba::srvregister { "$srv_dns":
     ensure => present,
   }
}
