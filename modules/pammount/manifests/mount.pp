define pammount::mount(
   $mountpoint=$title,
   $path,
   $fstype = undef,
   $options = undef,
   $noroot = undef,
   $server = undef,
   $sgrp = undef,
   $order = '10',
) {

   include pammount

   concat::fragment{ "pammount_${title}":
      target  => 'pam_mount.conf.xml',
      order   => $order,
      content => template('pammount/pam_mount.conf.xml.mount.erb'),
   }

}
   

