node 'example_pdc.samdom.com' {
   include stdlib
   class { 'network': }
   class { 'samba::pdc':
      disable_pam => true,
      disable_groups => true,
      account_server => true,
      print_server => true,
   }
   class { 'dhcp': }
   class { 'apt::server': }
   class { 'puppet::camaster': }
   class { 'cups':
      disable_lpupdate => true,
   }
   class { 'debbug::sambaserver': }
   class { 'wine::server': }
}

node 'example_dc.samdom.com' {
   include stdlib
   class { 'network': }
   class { 'samba::pdc':
      rsync_sysvol => true,
      disable_pam => true,
      disable_groups => true,
      account_server => true,
      print_server => true,
   }
   class { 'apt::server': }
   #class { 'puppet::master': }
   class { 'cups':
      disable_lpupdate => true,
   }
   class { 'debbug::sambaserver': }
}


node change_to__default__ {

   include stdlib
 
   #########
   # setup #
   #########
   class { 'network':
      stage => 'setup',
   }
   class { 'apt::client':
      stage => 'setup',
   }
   class { 'puppet::client':
      stage => 'setup',
      require => Class['apt::client'],
   }
   #class { 'concat::setup':
   #   stage => 'setup',
   #   require => Class['apt::client'],
   #}
   class { ['samba','samba::member']:
      stage => 'setup',
      require => Class['apt::client'],
   }
   class { ['pammount','nfs','nfs::client','nfs::client::dnfsmount']:
      stage => 'setup',
      require => Class['apt::client'],
   }
   class { 'wine::client::setup':
      stage => 'setup',
   }
 
   ########
   # main #
   ######## 
   class { 'wifi': }
   class { 'grub': }
   class { 'desktop': }
   class { 'cups': }
   ##class { 'check-quota': }
   class { 'keyboard': }
   class { 'shutdown': }
   class { 'mozilla':
      require => Class['desktop'],
   }
   #class { 'virt': }
   class { 'localization': }

   ###########
   # runtime #
   ###########
   class { 'hostpkg':
      stage => 'runtime',
   }
   class { 'extrapkg':
      stage => 'runtime',
   }
   class { 'wine::client':
      stage => 'runtime',
   }
   class { 'debbug::client':
      stage => 'runtime',
   }
}
