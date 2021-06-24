class cups::config {

   $web_access = $cups::web_access

   #############################
   # let access to the network #
   #############################
   file_option { 'cups_listen_interface':
      path => '/etc/cups/cupsd.conf',
      option => 'Listen',
      value => "${ipaddress}:631",
      separator => ' ',
      multiple => true,
      ensure => present,
   }

   file_line { 'cups_web_access':
      path => '/etc/cups/cupsd.conf',
      line => "  Allow $web_access",
      after => '<Location />',
      ensure => present,
   }

   # added two spaces at end of line #
   # to separate from previous ressource  #
   file_line { 'cups_admin_web_access':
      path => '/etc/cups/cupsd.conf',
      line => "  Allow $web_access  ",
      after => '<Location /admin>',
      ensure => present,
   }


   ####################
   # disable browsing #
   ####################
   file_option { 'cups_disable_remote_browse':
      path => '/etc/cups/cups-browsed.conf',
      option => 'BrowseRemoteProtocols',
      value => 'none',
      separator => ' ',
      multiple => false,
      ensure => present,
   }

   file_option { 'cups_disable_local_browse':
      path => '/etc/cups/cups-browsed.conf',
      option => 'BrowseLocalProtocols',
      value => 'none',
      separator => ' ',
      multiple => false,
      ensure => present,
   }

   file_option { 'cups_disable_browse':
      path => '/etc/cups/cups-browsed.conf',
      option => 'BrowseProtocols',
      value => 'none',
      separator => ' ',
      multiple => false,
      ensure => present,
   }
}
