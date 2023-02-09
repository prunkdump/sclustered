class wine::client::install {

   $apps = $wine::client::apps
   $enabled = $wine::client::enabled
   $associate = $wine::client::associate
   

   if ! empty($apps) or $enabled == true {
   
      package { ['unionfs-fuse','wine','wine64','wine32']:
         ensure => installed,
      }

      file { 'wine-wrapper':
         path    => '/usr/bin/wine-wrapper',
         ensure  => file,
         source => "puppet:///modules/wine/wine-wrapper",
         mode => '0755',
      }

   }
   else {

      package { ['wine','wine64','wine32']:
         ensure => absent,
      }
   }
}
