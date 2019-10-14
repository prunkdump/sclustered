class apt::autoupdate (
   $autoupdates = [],
   $autoupdate_blacklist = [],
   $autoupdate_times = [],
   $autoupdate_reboot = false
)  {

   ############
   # packages #
   ############
   package { unattended-upgrades:
      ensure => installed,
   }

   ##########
   # config #
   ##########
   file { '50unattended-upgrades':
      path => '/etc/apt/apt.conf.d/50unattended-upgrades',
      ensure => file,
      content => template('apt/50unattended-upgrades.erb'),
      mode => '0644',
      require => Package['unattended-upgrades'],
   }

   file { '20auto-upgrades':
      path => '/etc/apt/apt.conf.d/20auto-upgrades',
      ensure => file,
      source => 'puppet:///modules/apt/20auto-upgrades',
      mode => '0644',
      require => Package['unattended-upgrades'],
   }

   ##########
   # timers #
   ##########
   file { '/lib/systemd/system/apt-daily.timer':
      ensure => file,
      content => template('apt/apt-daily.timer.erb'),
      mode => '0644',
      require => Package['unattended-upgrades'],
   }

   service { 'apt-daily.timer':
      ensure => running,
      enable => true,
      require => Package['unattended-upgrades'],
      subscribe => File['/lib/systemd/system/apt-daily.timer'],
   }

   file { '/lib/systemd/system/apt-daily-upgrade.timer':
      ensure => file,
      content => template('apt/apt-daily-upgrade.timer.erb'),
      mode => '0644',
      require => Package['unattended-upgrades'],
   }

   service { 'apt-daily-upgrade.timer':
      ensure => running,
      enable => true,
      require => Package['unattended-upgrades'],
      subscribe => File['/lib/systemd/system/apt-daily-upgrade.timer'],
   }

}
   
