class wifi::install {

   package { 'wpasupplicant':
      ensure => installed,
   }

}
