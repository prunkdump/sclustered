# install packages in theme #
define hostpkg::theme_package( $theme = $title, $themes_hash ) {

   ensure_packages($themes_hash[$title],{
      ensure => installed,
   })

}


class hostpkg (
   $themes = $hostpkg::params::themes,
   $install_apps = $hostpkg::params::install_apps,
   $remove_apps = $hostpkg::params::remove_apps,
   $install_themes = $hostpkg::params::install_themes
) inherits hostpkg::params {

   #######################
   #   install themes    #
   #######################
   if( $themes ) {
      hostpkg::theme_package { $install_themes:
         themes_hash => $themes,
      }
   }

   ######################
   #  install packages  #
   ######################
   if( $install_apps ){
      ensure_packages($install_apps,{
         ensure => installed,
      })   
   }

   #####################
   #  remove packages  #
   #####################
   if( $remove_apps ){
      package { $remove_apps:
         ensure => absent,
      }
   }
}

