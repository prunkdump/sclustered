class wolenable::install {

   # need ethtool #
   package { 'ethtool':
      ensure => installed,
   }

   # need wolenable script #
   file { '/usr/sbin/wolenable':
      ensure => file,
      source => 'puppet:///modules/wolenable/wolenable',
      mode => '0755',
      require => Package['ethtool'],
   }

   # need wolenable service #
   file { '/etc/systemd/system/wolenable.service':
      ensure => file,
      source => 'puppet:///modules/wolenable/wolenable.service',
      mode => '0644',
      require => [Package['ethtool'],File['/usr/sbin/wolenable']],
   }
}
