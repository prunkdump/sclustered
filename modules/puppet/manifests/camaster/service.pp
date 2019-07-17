class puppet::camaster::service {

   $casrv_dns = $puppet::camaster::casrv_dns
   $mastersrv_dns = $puppet::camaster::mastersrv_dns

   # puppet service #
   service { 'apache2':
      ensure => running,
      enable => true,
   }

   # ca service register #
   samba::srvregister { "$casrv_dns":
      ensure => present,
      require => Service['apache2'],
   }    

   # puppet service register #
   samba::srvregister { "$mastersrv_dns":
      ensure => present,
      require => Service['apache2'],
   }
}
