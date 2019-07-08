class nfs::config {

   # needed vars #
   $translations = $nfs::translations

   include samba
   $samba_domain = $::samba::domain
   

   # enable idmapd #
   file_option { 'nfs_common_enable_idmapd':
      path => '/etc/default/nfs-common',
      option => 'NEED_IDMAPD',
      separator => '=',
      value => "yes",
      ensure => present,
   }

   ####################
   # idmapd fragments #
   ####################

   concat { '/etc/idmapd.conf':
     ensure => present,
     mode => '0644',
   }

   concat::fragment { 'idmapd_header':
      target => '/etc/idmapd.conf',
      content => template('nfs/idmapd.conf.erb'),
      order => '10',
   }

}
