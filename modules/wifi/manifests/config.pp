class wifi::config {
 
   $interface = $wifi::interface
   $disabled_interfaces = $wifi::disabled_interfaces
   $ssid = $wifi::ssid
   $psk = $wifi::psk

   file { '/etc/network/interfaces':
      ensure => present,
      content => template('wifi/interfaces.erb'),
      mode => '0644',
   }

   file { '/etc/network/interfaces.d':
      ensure => directory,
   }

   file { "/etc/network/interfaces.d/$interface":
     ensure => present,
     content => template('wifi/wifipass.erb'),
     mode => '0600',
     require => File['/etc/network/interfaces.d'],
   }

   # some old configuration files may conflict with /etc/network/interfaces #
   $disabled_interfaces_files = $disabled_interfaces.map |$dis_interface| { "/etc/network/interfaces.d/${dis_interface}" }
   file { $disabled_interfaces_files:
      ensure => absent,
   }

}
