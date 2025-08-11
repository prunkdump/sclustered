class debbug::client {

   # BUG gdm failed to restart #
   # see modules/desktop/manifests/gnome/service.pp
   # and modules/desktop/manifests/gnome.pp 

   # RESOLVED
   # BUG puppet start before network is online
   # see also modules/puppet/templates/script_10-main.erb
   #file_option { 'start_puppet_after_network':
   #   path => '/lib/systemd/system/puppet.service',
   #   option => 'After',
   #   value => 'network.target network-online.target remote-fs.target systemd-networkd.service NetworkManager.service',
   #   separator => '=',
   #   after => 'Documentation=man:puppet-agent\(8\)',
   #   multiple => false,
   #   ensure => present,
   #}
   #
   #exec { 'puppet-service-daemon-reload':
   #   path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
   #   command => 'systemctl daemon-reload',
   #   refreshonly => true,
   #   subscribe => File_option['start_puppet_after_network'],
   #}

   # RESOLVED
   # BUG winbind fail to start when trusted domain is disabled #
   #
   # see : modules/samba/templates/member_smb.conf.erb
   #
   # follow :
   # https://bugzilla.samba.org/show_bug.cgi?id=14899

   # BUG winbind fail on suspend #
   # BUG dhclient does not update timers on suspend #
   # BUG ntp dhclient exit hook make winbind failed on DHCPDISCOVER #
   file { '/lib/systemd/system/suspend-bugs.service':
      ensure => present,
      source => 'puppet:///modules/debbug/suspend-bugs.service',
      mode => '0644',
   }

   file { '/sbin/dhclient-exit':
      ensure => present,
      source => 'puppet:///modules/debbug/dhclient-exit',
      mode => '0755',
   }

   file_option { 'add_networking_reload':
      path => '/lib/systemd/system/networking.service',
      option => 'ExecReload',
      value => '/sbin/ifup --force -a --read-environment',
      separator => '=',
      after => 'ExecStop',
      multiple => false,
      ensure => present,
   }

   exec { 'networking-service-daemon-reload':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe => [File['/lib/systemd/system/suspend-bugs.service'],File_option['add_networking_reload']],
   }

   service { 'suspend-bugs':
      enable => true,
      require => [File['/lib/systemd/system/suspend-bugs.service','/sbin/dhclient-exit'],
                  File_option['add_networking_reload'],
                  Exec['networking-service-daemon-reload']],
   }

   exec { 'winbind_suspend_bug_restart':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload && systemctl restart winbind',
      refreshonly => true,
      require => Service['suspend-bugs'],
      subscribe => File['/lib/systemd/system/suspend-bugs.service'],
   }

   # bug Gssd make looping dns request when the credential cache expire #
   # so check the users logged on wake #
   file { '/lib/systemd/system/gssd-bug.service':
      ensure => present,
      source => 'puppet:///modules/debbug/gssd-bug.service',
      mode => '0644',
   }

   file { '/sbin/check-gssd-cache':
      ensure => present,
      source => 'puppet:///modules/debbug/check-gssd-cache',
      mode => '0755',
   }

   exec { 'gssd-service-daemon-reload':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload && /sbin/check-gssd-cache',
      refreshonly => true,
      subscribe => File['/lib/systemd/system/gssd-bug.service','/sbin/check-gssd-cache'],
   }

   service { 'gssd-bug':
      enable => true,
      require => [File['/lib/systemd/system/gssd-bug.service','/sbin/check-gssd-cache'],
                  Exec['gssd-service-daemon-reload']],
   }

   # bug : sometimes nfs cache some nobody/nogroup at boot #
   # so clear the cache when nfs-client and winbind are started#
   file { '/lib/systemd/system/idmap-clean.service':
      ensure => present,
      source => 'puppet:///modules/debbug/idmap-clean.service',
      mode => '0644',
   }

   exec { 'idmap-clean-service-daemon-reload':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe => File['/lib/systemd/system/idmap-clean.service'],
   }

   service { 'idmap-clean':
      enable => true,
      require => [File['/lib/systemd/system/idmap-clean.service'],
                  Exec['idmap-clean-service-daemon-reload']],
   }


   # nullmailer can fill disk with certain cron scripts #
   service { 'nullmailer':
      ensure => stopped,
      enable => false,
   }

   # bug cusps disable printers #
   # see cups module #

   # !!! don't works with efi !!! #
   # grub failed to upgrade #
   #file { '/usr/sbin/debbug-grub-repair':
   #   ensure => present,
   #  source => 'puppet:///modules/debbug/debbug-grub-repair',
   #   mode => '0755',
   #}
   #
   #exec { 'check-grub-device':
   #   path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
   #   command => '/usr/sbin/debbug-grub-repair',
   #   unless => "echo 'get grub-pc/install_devices' | debconf-communicate | grep -q '/dev'",
   #   require => File['/usr/sbin/debbug-grub-repair'],
   #}

}
