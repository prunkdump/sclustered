class nfs::server::config {

   # get needed vars #
   $root_path = $nfs::server::root_path
   $network = $nfs::server::network
   $daemon_count = $nfs::server::daemon_count
   $export_options = $nfs::server::export_options
   $nfs4_export_options = $nfs::server::nfs4_export_options

   $nfs4_options = concat($nfs4_export_options, $export_options)
   $nfs4_options_str = join($nfs4_options,',') 

   # get samba params #   
   include samba
   $samba_domain = $::samba::domain
   $base_dn = $::samba::base_dn
   $private_path = $::samba::private_path

   ########################
   # configure nfs server #
   ########################

   # set nfsd count #
   file_option { 'nfs_server_nfsd_count':
      path => '/etc/default/nfs-kernel-server',
      option => 'RPCNFSDCOUNT',
      value => "$daemon_count",
      separator => '=',
      ensure => present,
   }
   
   # nfs4 use now gssproxy #
   file_option { 'nfs_server_disable_svcgssd':
      path => '/etc/default/nfs-kernel-server',
      option => 'NEED_SVCGSSD',
      value => 'no',
      separator => '=',
      ensure => present,
   }

   # gssproxy conf #
   file { '/etc/gssproxy/24-nfs-server.conf':
      ensure => present,
      source => 'puppet:///modules/nfs/24-nfs-server.conf',
      mode => '0644',
   }

   file { '/etc/gssproxy/99-nfs-client.conf':
      ensure => present,
      source => 'puppet:///modules/nfs/99-nfs-client.conf',
      mode => '0644',
   }

   ####################
   # samba spn config #
   ####################

   # create the nfs keytab with strong enctypes #
   exec{ 'create_nfs_keytab':
      command => "samba-tool user add nfs-$hostname --random-password && \
                  samba-tool spn add nfs/${hostname}.${samba_domain} nfs-${hostname} && \
                  echo 'dn: CN=nfs-${hostname},CN=Users,${base_dn}\nchangetype: modify\nadd: msDS-SupportedEncryptionTypes\nmsDS-SupportedEncryptionTypes: 31' | ldbmodify -H ${private_path}/sam.ldb && \
                  samba-tool domain exportkeytab /etc/krb5.keytab --principal=nfs/${hostname}.${samba_domain}",
      path => '/usr/bin:/usr/sbin:/bin',
      unless => "klist -k /etc/krb5.keytab | grep 'nfs/${hostname}.${samba_domain}'",
      require => Class['samba'],
   }

   ##################
   # exports config #
   ##################

   # create nfs root path #
   exec { "mkdir -p ${root_path}":
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "${root_path}",
   }

   # exports fragments #
   concat { '/etc/exports':
      ensure => present,
      mode => '0644',
   }

   # main nfs4 export #
   concat::fragment { "nfs_nfs4_fsid0_export":
      target => '/etc/exports',
      content => "${root_path}               ${network}(fsid=0,crossmnt,$nfs4_options_str)\n",
      order => '10',
   }

   # allow other applications to use nfs #
   file { '/etc/exports.d':
      ensure => directory,
   }

   file { '/etc/exports.d/export.template':
      ensure => file,
      content => "${root_path}               ${network}($nfs4_options_str)\n",
   }
   
}
