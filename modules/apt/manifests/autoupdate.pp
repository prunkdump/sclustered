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

   # download time #
   if length($autoupdate_times) >= 1 {
      $apt_daily_override_status = file
   } else {
      $apt_daily_override_status = absent
   }

   file { '/etc/systemd/system/apt-daily.timer.d':
      ensure => directory,
   }

   file { '/etc/systemd/system/apt-daily.timer.d/override.conf':
      ensure => $apt_daily_override_status,
      content => template('apt/apt-daily-timer-override.conf.erb'),
      mode => '0644',
      require => [Package['unattended-upgrades'], File['/etc/systemd/system/apt-daily.timer.d']],
   }

   service { 'apt-daily.timer':
      ensure => running,
      enable => true,
      require => Package['unattended-upgrades'],
      subscribe => File['/lib/systemd/system/apt-daily.timer'],
   }


   # upgrade time #
   if length($autoupdate_times) >= 2 {
      $apt_daily_upgrade_override_status = file
   } else {
      $apt_daily_upgrade_override_status = absent
   }

   file { '/etc/systemd/system/apt-daily-upgrade.timer.d':
      ensure => directory,
   }

   file { '/etc/systemd/system/apt-daily-upgrade.timer.d/override.conf':
      ensure => $apt_daily_upgrade_override_status,
      content => template('apt/apt-daily-upgrade-timer-override.conf.erb'),
      mode => '0644',
      require => [Package['unattended-upgrades'], File['/etc/systemd/system/apt-daily-upgrade.timer.d']],
   }

   service { 'apt-daily-upgrade.timer':
      ensure => running,
      enable => true,
      require => Package['unattended-upgrades'],
      subscribe => File['/lib/systemd/system/apt-daily-upgrade.timer'],
   }
}
