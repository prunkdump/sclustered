class desktop (
   $environment = $desktop::params::environment,
   $force_mirror = $desktop::params::force_mirror,
   $disable_wayland = $desktop::params::disable_wayland
) inherits desktop::params {

   anchor { 'desktop::begin': }
   case $environment {
      'gnome': { 
         class { 'desktop::gnome':
            require => Anchor['desktop::begin'],
            before => Anchor['desktop::end'],
         }
      }
      'xfce' : {
         class { 'desktop::xfce': 
            require => Anchor['desktop::begin'],
            before => Anchor['desktop::end'],
         }
      }
      'native' : {

      }
      default : { 
         class { 'desktop::gnome': 
            require => Anchor['desktop::begin'],
            before => Anchor['desktop::end'],
         }
      }
   }
   class { 'desktop::install': }->
   class { 'desktop::config': }~>
   class { 'desktop::display':
      force_mirror => $force_mirror,
      disable_wayland => $disable_wayland,
   }~>
   class { 'desktop::service': }->
   anchor { 'desktop::end': } 
}


