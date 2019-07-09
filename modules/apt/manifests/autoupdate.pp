class apt::autoupdate (
   $autoupdates,
   $autoupdate_blacklist
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
}
   
