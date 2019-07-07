class pammount::install {

   package { 'libpam-mount':
      ensure => installed,
   }
   

   file { 'mount.fuse.expanded':
      path => '/sbin/mount.fuse.expanded',
      ensure => present,
      source => 'puppet:///modules/pammount/mount.fuse.expanded',
      mode => '0755',
   }

}

