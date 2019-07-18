class puppet::client::service {

   # puppet service #
   service { 'puppet':
      ensure => running,
      enable => true,
   }

}
