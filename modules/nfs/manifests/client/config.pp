class nfs::client::config {

   $enable_cachefilesd = $nfs::client::enable_cachefilesd
   $samba_domain = $nfs::client::samba_domain

   ################
   # kernel setup #
   ################
   file { '/etc/sysctl.d/12-nfskeys.conf':
      ensure => present,
      source => 'puppet:///modules/nfs/12-nfskeys.conf',
      mode => '0644',
   }

   exec {'update_nfs_kernel_params':
         command => "sysctl -p /etc/sysctl.d/12-nfskeys.conf",
         path => '/sbin:/usr/bin:/usr/sbin:/bin',
         require => File['/etc/sysctl.d/12-nfskeys.conf'],
         subscribe => File['/etc/sysctl.d/12-nfskeys.conf'],
         refreshonly => true,
   }


   ##########
   # config #
   ##########

   # enable gssd #
   file_option { 'nfs_common_enable_gssd':
      path => '/etc/default/nfs-common',
      option => 'NEED_GSSD',
      separator => '=',
      value => "yes",
      ensure => present,
      notify => Class['nfs::service'],
   }

   # create the machines keytab #
   $principal = upcase("${::hostname}")
   exec{ 'create_machine_keytab':
      command => "samba-tool domain exportkeytab /etc/krb5.keytab --principal=${principal}\$ || net ads keytab create -P",
      path => '/usr/bin:/usr/sbin:/bin',
      unless => "klist -k /etc/krb5.keytab | grep '${principal}'",
      require => Class['samba'],
   }

   # cachefiled config #
   if $enable_cachefilesd == true {
      file { 'cachefilesd':
         path => '/etc/default/cachefilesd',
         ensure => file,
         source => 'puppet:///modules/nfs/cachefilesd',
         mode => '0644',
      }
   }

   
}

