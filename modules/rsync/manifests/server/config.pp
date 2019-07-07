class rsync::server::config {

   # enable service default #
   file_option { 'enable_rsync_service':
      path => '/etc/default/rsync',
      option => 'RSYNC_ENABLE',
      value => 'true',
      separator => '=',
      multiple => false,
      ensure => present,
      require => Package['rsync'],
   }

   ###################################
   # the other modules can add lines #
   ###################################
   file { '/etc/rsyncd.conf':
      ensure => file,
      mode => '0644',
   }

}
