class wine::client::install {

   $apps = $wine::client::apps
   $enabled = $wine::client::enabled
   $associate = $wine::client::associate
   

   if ! empty($apps) or $enabled == true {
   
      package { ['unionfs-fuse','wine-development','wine32-development']:
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

      package { ['wine-development','wine32-development']:
         ensure => absent,
      }
   }
}
