class debbug::client {

   # BUG gdm failed to restart #
   # see modules/desktop/manifests/gnome/service.pp
   # and modules/desktop/manifests/gnome.pp 

   # BUG puppet start before network is online
   # see also modules/puppet/templates/script_10-main.erb
   file_option { 'start_puppet_after_network':
      path => '/lib/systemd/system/puppet.service',
      option => 'After',
      value => 'network.target network-online.target remote-fs.target systemd-networkd.service NetworkManager.service',
      separator => '=',
      after => 'Documentation=man:puppet-agent\(8\)',
      multiple => false,
      ensure => present,
   }

   exec { 'puppet-service-daemon-reload':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe => File_option['start_puppet_after_network'],
   }


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
      subscribe => File_option['add_networking_reload'],
   }

   service { 'suspend-bugs':
      enable => true,
      require => [File['/lib/systemd/system/sleep-winbind.service','/sbin/dhclient-exit'],
                  File_option['add_networking_reload'],
                  Exec['networking-service-daemon-reload'],
   }

   exec { 'winbind_suspend_bug_restart':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl restart winbind',
      refreshonly => true,
      require => Service['suspend-bugs'],
      subscribe => File['/lib/systemd/system/suspend-bugs.service'],
   }

   # nullmailer can fill disk with certain cron scripts #
   service { 'nullmailer':
      ensure => stopped,
      enable => false,
   }


}
