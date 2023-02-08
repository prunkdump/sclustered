class dhcp::config {
   $interfaces = $dhcp::interfaces
   $network = $dhcp::network
   $netmask = $dhcp::netmask
   $routers = $dhcp::routers
   $default_lease_time = $dhcp::default_lease_time
   $max_lease_time = $dhcp::max_lease_time
   $domain_name = $dhcp::domain_name
   $domain_name_servers = $dhcp::domain_name_servers
   $pxe_server = $dhcp::pxe_server
   $pxe_filename = $dhcp::pxe_filename
   $pxe_efi_filename = $dhcp::pxe_efi_filename
   $ntp_servers = $dhcp::ntp_servers
   $options = $dhcp::options
   $default_network = $dhcp::default_network
   $default_netmask = $dhcp::default_netmask
   $default_range = $dhcp::default_range
   $default_options = $dhcp::default_options  
   $fixed_hosts = $dhcp::fixed_hosts
   $pool_hosts = $dhcp::pool_hosts
   $pools = $dhcp::pools
   $classes = $dhcp::classes
   $fai_hosts = $dhcp::fai_hosts

   ##########
   # config #
   ##########

   $interfaces_flat = join($interfaces, ' ')

   # set interfaces #
   file_option { 'isc_dhcp_interfaces':
      path => '/etc/default/isc-dhcp-server',
      option => 'INTERFACESv4',
      separator => '=',
      value => "\"$interfaces_flat\"",
      ensure => present,
   }
 

   # need to be authoritative #
   file_line { 'insert_dhcp_authoritative' :
      path => '/etc/dhcp/dhcpd.conf',
      line => 'authoritative;',
      match => '^\s*#\s*authoritative\s*;',
      ensure => present,
      multiple => false,
   }

   # include main configuration file #
   file_line { 'insert_dhcp_s4conf' :
      path => '/etc/dhcp/dhcpd.conf',
      line => 'include "/etc/dhcp/s4dhcp.conf";',
      ensure => present,
      multiple => false,
   }

   # main configuration file  #
   file { '/etc/dhcp/s4dhcp.conf':
      ensure => file,
      content => template('dhcp/s4dhcp.conf.erb'),
      mode => '0644',
   }

   # conf directory #
   file { '/etc/dhcp/conf':
      ensure => directory,
   }


   # samba network parameters  #
   file { '/etc/dhcp/conf/01s4_net.conf':
      ensure => file,
      content => template('dhcp/01s4_net.conf.erb'),
      mode => '0644',
      require => File['/etc/dhcp/conf'],
   }
   
   # samba network classes #
   file { '/etc/dhcp/conf/02s4_class.conf':
      ensure => file,
      content => template('dhcp/02s4_class.conf.erb'),
      mode => '0644',
      require => File['/etc/dhcp/conf'],
   }

   # host classes #
   file { '/etc/dhcp/conf/free_class.conf':
      ensure => file,
      mode => '0644',
      require => File['/etc/dhcp/conf'],
   }

   file { '/etc/dhcp/conf/host_class.conf':
      ensure => file,
      mode => '0644',
      content => template('dhcp/host_class.conf.erb'),
      require => File['/etc/dhcp/conf'],
   }

   file { '/etc/dhcp/conf/fai_class.conf':
      ensure => file,
      mode => '0644',
      content => template('dhcp/fai_class.conf.erb'),
      require => File['/etc/dhcp/conf'],
   }

   # samba network deny all other classes #
   file { '/etc/dhcp/conf/03default_deny.conf':
      ensure => file,
      content => template('dhcp/03default_deny.conf.erb'),
      mode => '0644',
      require => File['/etc/dhcp/conf'],
   }

   # srcipts to update a local dhcp database #
   file { '/usr/sbin/dhcp-host-update':
      ensure => file,
      source => 'puppet:///modules/dhcp/dhcp-host-update',
      mode => '0700',
   }

   file { '/usr/sbin/dhcp-hosts':
      ensure => file,
      source => 'puppet:///modules/dhcp/dhcp-hosts',
      mode => '0700',
   }

}
