class desktop::config {

   #file { '/usr/share/applications/passwd.desktop':
   #   ensure => present,
   #   mode => '0755',
   #   source => 'puppet:///modules/desktop/passwd.desktop',
   #}

   # disable avahi-daemon #
   file_option { 'restrict_avahi_to_lo':
      path => '/etc/avahi/avahi-daemon.conf',
      option => 'allow-interfaces',
      value => 'lo',
      separator => '=',
      multiple => false,
      ensure => present,
   }


}
