class keyboard::service {

   service { 'keyboard-setup':
      ensure => running,
   }

}
