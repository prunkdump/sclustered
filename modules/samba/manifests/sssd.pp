class samba::sssd {

   include samba
   $domain = $samba::domain   

   ###########
   # install #
   ###########
   package { 'sssd':
      ensure => installed,
   }

   ##########
   # config #
   ##########
   file { 'sssd.conf':
      path => "/etc/sssd/sssd.conf",
      ensure => file,
      content => template('samba/sssd.conf.erb'),
      mode => '0600',
      require => Package['sssd'],
   }

   ###########
   # service #
   ###########   
   service {'sssd':
      ensure    => running,
      enable    => true,
      subscribe => File['sssd.conf'],
   } 
}

