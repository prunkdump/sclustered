class samba::bind_setup (
   $domain,
   $network,
   $dns_forwarders,
   $binddlz_path,
   $lib_path
) {
   ############
   # packages #
   ###########

   package { ['bind9', 'ldb-tools']:
      ensure => installed,
   }

   ###################
   # set permissions #
   ###################
   
   # set permission to bind #
   # to samba files #
   file { "$binddlz_path":
      ensure => directory,
      owner => 'bind',
      group => 'bind',
      mode => '0770', 
      require => Package['bind9'],
   }

   exec { 'samba_bind_dns_chown':
      command => "chown -R bind:bind $binddlz_path/dns",
      path => '/usr/bin:/usr/sbin:/bin',
      subscribe => File["$binddlz_path"],
      refreshonly => true,
      require => Package['bind9'],
   }

   file {"$binddlz_path/dns.keytab":
      ensure => file,
      group => 'bind',
      mode => '0640',
      require => Package['bind9'],
   }

   #############
   # configure #
   #############

   file { '/etc/bind/named.conf.options':
      ensure => file,
      content => template('samba/named.conf.options.erb'),
      mode => '0644',
      require => Package['bind9'],
   }

   file_line { 'insert_bind_dlz' :
      path => '/etc/bind/named.conf',
      line => 'include "/etc/bind/named.conf.samba";',
      after => '\s*include.*named\.conf\.local',
      ensure => present,
      multiple => false,
      require => Package['bind9'],
   }

   # changed to include, this give the path to the DLZ module #
   file { '/etc/bind/named.conf.samba' :
      ensure => file,
      content => "include \"$binddlz_path/named.conf\";",
      mode => '0644',
      require => Package['bind9'],
   }

   file { "$binddlz_path/named.conf" :
      ensure => file,
      owner => 'bind',
      group => 'bind',
      content => template('samba/named.conf.samba.erb'),
      mode => '0644',
      require => Package['bind9'],
   }
   
   ##################
   # dns transition #
   ##################

   # bind need to be restarted now ! #
   service { 'bind9':
      ensure => running,
      enable => true,
      subscribe => [File["$binddlz_path","$binddlz_path/dns.keytab",
                         '/etc/bind/named.conf.options','/etc/bind/named.conf.samba',"$binddlz_path/named.conf"],
                   Exec['samba_bind_dns_chown'],
                   File_line['insert_bind_dlz']],
   }
  
   # update resolv.conf #
   file { '/etc/resolv.conf' :
      ensure => file,
      content => template('samba/resolv.conf.erb'),
      mode => '0644',
      require => Service['bind9'],
   }
}
