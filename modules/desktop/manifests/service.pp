class desktop::service {

   # cause problem with the cups module #
   # now disabled in config.pp

   #service { 'avahi-daemon':
   #   ensure => stopped,
   #   enable => false,
   #}
   #

   if defined( Class['desktop::gnome'] ) or defined( Class['desktop::xfce'] ) {
      service { 'avahi-daemon':
         ensure => running,
         enable => true,
      }
   }
}
