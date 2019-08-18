class wine::client::setup {

   include samba
   include wine

   $apps = $::wine::apps
   $enabled = $::wine::enabled
   $associate = $::wine::associate

   $samba_users_group = $::samba::users_group

   if ! empty($apps) or $enabled == true {

      ###################
      # need multi arch #
      ###################
      include apt::client::multiarch
   }


   # shared wine prefixes are only needed when #
   # some apps are enabled                     #
   if ! empty($apps) {

      ##################################
      # pam mount shared wine prefixes #
      ##################################
      pammount::mount { 'pam_mount_wine_tmpfs':
         mountpoint => '/run/wine/%(USERUID)',
         path => 'tmpfs',
         fstype => 'tmpfs',
         options => 'nosuid,nodev,mode=700,uid=%(USERUID)',
         sgrp => "${samba_users_group}",
         order => '11',
      }

      pammount::mount { 'pam_mount_wine_unionfs':
         mountpoint => '/run/wine/%(USERUID)/prefixes',
         #path => 'unionfs-fuse#~/.winediff=RW:/dnfs/wine=RO',
         path => 'unionfs-fuse#~/.winediff=RW:/wine=RO',
         fstype => 'fuse',
         options => 'cow,uid=%(USERUID),gid=%(USERGID)',
         sgrp => "${samba_users_group}",
         order => '12',
      }
   }
}
