class desktop::gnome::dconf {

   ################
   # dconf update #
   ################

   exec { 'dconf update':
      path => '/usr/bin:/usr/sbin:/bin',
      refreshonly => true,
   }

}

