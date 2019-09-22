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


   # BUG winbind fail on suspend: dns lookup don't works on resume #
   file { '/lib/systemd/system/sleep-winbind.service':
      ensure => present,
      source => 'puppet:///modules/debbug/sleep-winbind.service',
      mode => '0644',
   }

   service { 'sleep-winbind':
      enable => true,
      require => File['/lib/systemd/system/sleep-winbind.service'],
   }

   service { 'winbind_debbug':
      name => 'winbind',
      ensure => running,
      require => Service['sleep-winbind']
      subscribe => File['/lib/systemd/system/sleep-winbind.service'],
   }

}
