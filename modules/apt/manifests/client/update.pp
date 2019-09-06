class apt::client::update {

   $distribution = $apt::client::distribution

   # refresh if source.list or keys are updated #   
   exec { 'apt-get update':
      path => '/usr/bin:/usr/sbin:/bin',
      refreshonly => true,
   }

   # prevent restarting puppet on upgrade #
   file { '/usr/sbin/policy-rc.d':
      path => '/usr/sbin/policy-rc.d',
      ensure => file,
      source => 'puppet:///modules/apt/policy-rc.d',
      mode => '0755',
   }

   # check dist-upgrade #
   package { 'lsb-release':
      ensure => present,
   }

   # update all packages except puppet, will be upgraded with unattended upgrades #
   exec { 'debian_automated_distupgrade':
      path => '/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
      command => "echo 'puppet hold' | dpkg --set-selections && env DEBIAN_FRONTEND=noninteractive APT_LISTCHANGES_FRONTEND=mail apt-get dist-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' && echo 'puppet install' | dpkg --set-selections",
      require => [Exec['apt-get update'],File['/usr/sbin/policy-rc.d'],Package['lsb-release']],
      unless => "lsb_release -c | grep $distribution",
      timeout => 0,
   }
}
