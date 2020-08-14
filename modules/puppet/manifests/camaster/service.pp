class puppet::camaster::service {

   $compiler_only = $puppet::camaster::compiler_only
   $casrv_dns = $puppet::camaster::casrv_dns
   $mastersrv_dns = $puppet::camaster::mastersrv_dns
   $puppetcarsync_password = $puppet::camaster::puppetcarsync_password


   # puppet service #
   service { 'apache2':
      ensure => running,
      enable => true,
   }


   # if camaster, register #
   if $compiler_only != true {

      # ca service register #
      samba::srvregister { "$casrv_dns":
        ensure => present,
        require => Service['apache2'],
      }

   }

   # else rsync puppet configuration #
   else {

      rsync::replicate { 'puppetca':
         server => $casrv_dns,
         password => $puppetcarsync_password,
         src_files => ['/environments','/hieradata','/hiera.yaml','/modules'],
         dest_path => '/etc/puppet',
         minute => '*/15',
      }
   }

   # puppet service register #
   samba::srvregister { "$mastersrv_dns":
      ensure => present,
      require => Service['apache2'],
   }
}
