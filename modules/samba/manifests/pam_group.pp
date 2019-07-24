class samba::pam_group (
   $groups,
){

   #####################
   # install pam group #
   #####################
   file { '/usr/share/pam-configs/group':
      ensure => present,
      source => "puppet:///modules/samba/pam-config-group",
      mode => '0644',
   }

   exec { 'pam_group_auth_update' :
      command => 'pam-auth-update --force',
      path => '/usr/bin:/usr/sbin:/bin',
      subscribe => File['/usr/share/pam-configs/group'],
      refreshonly => true,
   }
   
   ############################
   # add users to base groups #
   ############################
   file { 'group.conf':
      path => '/etc/security/group.conf',
      ensure => present,
      content => template('samba/group.conf.erb'),
      mode => '0644',
   }

   file { '/etc/systemd/system/user@.service.d':
      ensure => directory,
      mode => '0755',
   }

   file { '/etc/systemd/system/user@.service.d/override.conf':
      ensure => present,
      content => template('samba/override.conf.erb'),
      mode => '0644',
      require => File['/etc/systemd/system/user@.service.d'],
   }


   
}


