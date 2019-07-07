class rsync::server {

   # install rsync #
   include rsync

   # not anchor #
   # can be used as dependencies for other modules #
   class { 'rsync::server::config':
      require => Class['rsync'],
   }~>
   class { 'rsync::server::service': }

}
