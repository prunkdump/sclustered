define rsync::server::export (
   $path,
   $password
) {

   include rsync::server

   ##############
   # add export #
   ##############
   file_line { "rsync_export_${name}":
      path => '/etc/rsyncd.conf',
      line => "&include /etc/rsyncd-${name}.conf",
      ensure => present,
      multiple => false,
      require => Class['rsync::server::config'],
      notify => Class['rsync::server::service'],
   }

   file { "/etc/rsyncd-${name}.conf":
      ensure => file,
      content => template('rsync/rsyncd-export.conf.erb'),
      mode => '0644',
      require => Class['rsync::server::config'],
      notify => Class['rsync::server::service'],
   }
   
   file { "/var/lib/rsync/rsyncd-${name}.secret":
      ensure => file,
      content => template('rsync/rsyncd-export.secret.erb'),
      mode => '0600',
      require => Class['rsync::server::config'],
      notify => Class['rsync::server::service'],
   }
   
}
