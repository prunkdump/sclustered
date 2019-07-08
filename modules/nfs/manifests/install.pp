class nfs::install {

   # keyutils is used to make dns resolution in nfs #
   package { [nfs-common,keyutils,nfs4-acl-tools]:
      ensure => installed,
   }

}
