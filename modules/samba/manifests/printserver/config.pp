class samba::printserver::config (
   $etc_path
) {

   ######################
   # create directories #
   ######################
   file { ['/var/spool','/srv/samba']:
      ensure => directory,
   }

   file { '/var/spool/samba':
      ensure => directory,
      mode => '1777',
      require => File['/var/spool'],
   }

   # moved to postconfig #
   #file { '/srv/samba/Printer_drivers':
   #   ensure => directory,
   #   mode => '2755',
   #   require => File['/srv/samba'],
   #}

   ##############
   # samba conf #
   ##############

   # enable spoolss #
   file_option { 'samba_enable_external_spoolss':
      path => '/etc/samba/smb.conf',
      option => 'rpc_server:spoolss',
      value => 'external',
      after => '\[global\]',
      multiple => false,
      ensure => present,
   }

   file_option { 'samba_enable_spoolssd':
      path => '/etc/samba/smb.conf',
      option => 'rpc_daemon:spoolssd',
      value => 'fork',
      after => '\[global\]',
      multiple => false,
      ensure => present,
   }


   # load printers #
   file_option { 'samba_load_printers':
      path => '/etc/samba/smb.conf',
      option => 'load printers',
      value => 'yes',
      after => '\[global\]',
      multiple => false,
      ensure => present,
   }

   # use cups #
   file_option { 'samba_use_cups':
      path => '/etc/samba/smb.conf',
      option => 'printing',
      value => 'CUPS',
      after => '\[global\]',
      multiple => false,
      ensure => present,
   }

   # include printer shares #
   file_option { 'include_s4_printers.conf':
      path => "$etc_path/smb.conf",
      option => 'include',
      value => "$etc_path/s4_printers.conf",
      ensure => present,
      multiple => true,
   }

   # printer shares #
   file { 's4_printers.conf':
      path => "$etc_path/s4_printers.conf",
      ensure => file,
      content => template('samba/s4_printers.conf.erb'),
      mode => '0644',
   }

}
