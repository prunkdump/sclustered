class mozilla::install {

   package { ['firefox-esr','thunderbird']:
      ensure => installed,
   }

   # as Firefox does not support java plugin anymore #
   # install java machine separately                 #
   package { 'default-jre':
      ensure => installed,
   } 

}
