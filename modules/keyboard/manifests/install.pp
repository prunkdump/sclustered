class keyboard::install {

   $disable_numlock = $keyboard::disable_numlock

   # install numlockx #
   if $disable_numlock == false { 
      package { 'numlockx':
         ensure => installed,
      }
   } else {
      package { 'numlockx':
         ensure => absent,
      }
   }
}
