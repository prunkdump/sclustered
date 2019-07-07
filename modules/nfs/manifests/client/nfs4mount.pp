define nfs::client::nfs4mount (
   $path = $title,
   $host,
   $share,
   $options = undef,
   $options_additional = []
) {

   include nfs::client

   $mount_options = $nfs::client::mount_options
   $nfs4_mount_options = $nfs::client::nfs4_mount_options

   if $options {
      $global_options = concat($options, $options_additional)
   } else {
      $global_options_tmp = concat($nfs4_mount_options, $mount_options)
      $global_options = concat($global_options_tmp, $options_additional)
   }

   $global_options_str = join($global_options, ',')


   # create directory #
   exec { "mkdir -p ${path}":
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "${path}",
   }

   # mount nfs4 #
   exec { "mount -t nfs4 -o $global_options_str ${host}:${share} ${path}":
      path => '/usr/bin:/usr/sbin:/bin',
      unless => "mount | grep '${path}'",
      require => Class[nfs::client],
   }

   #mount { "$path":
   #   device => "${host}:${share}",
   #   fstype => nfs4,
   #   ensure => mounted,
   #   options => $global_options_str,
   #   remounts => false,
   #   atboot => false,
   #}
   

   ###############################
   # use sytemd to mount at boot #
   # after samba and bind9       #
   ###############################

   # create file name #
   $sharefilename_slash = "${path}.mount"
   $sharefilename_leading = regsubst($sharefilename_slash,'/','')
   $sharefilename = regsubst($sharefilename_leading,'/','-','G')
   

   file { "/lib/systemd/system/${sharefilename}":
      ensure => file,
      content => template('nfs/nfs4.mount.erb'),
      mode => '0644',
   }

   service { "$sharefilename":
      enable => true,
      require => File["/lib/systemd/system/${sharefilename}"],
   }

}
