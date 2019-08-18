define rsync::replicate (
   $server,
   $password,
   $src_files,
   $dest_path,
   $minute = '*',
   $hour = '*',
   $month = '*',
   $monthday = '*',
   $weekday = '*',
) {

   include rsync

   #################
   # password file #
   #################
   file { "/var/lib/rsync/rsync-${name}.secret":
      ensure => file,
      content => template('rsync/rsync-replicate.secret.erb'),
      mode => '0600',
      require => Class['rsync'],
   }


   ############
   # cron job #
   ############
   $replicate_rsync_command = 
inline_template("/usr/bin/rsync -XAavz --delete-after --password-file=/var/lib/rsync/rsync-<%= @name %>.secret \
<% @src_files.each do |file| %> \
rsync://<%= @name %>-replication@<%= @server %>/<%= @name %><%= file %> \
<% end %> \
<%= @dest_path %>")

   exec { "${name}_rsync_replicate":
      path => '/usr/bin:/usr/sbin:/bin',
      command => $replicate_rsync_command,
      subscribe => File["/var/lib/rsync/rsync-${name}.secret"],
      refreshonly => true,
   }


   cron { "${name}_rsync_replicate":
      command => $replicate_rsync_command,
      user => root,
      minute => $minute,
      hour => $hour,
      month => $month,
      monthday => $monthday,
      weekday => $weekday,
      require => File["/var/lib/rsync/rsync-${name}.secret"],
   }

   # to manually replicate #
   file { "/usr/sbin/replicate-${name}":
      ensure => file,
      content => "#! /bin/bash
                  $replicate_rsync_command",
      mode => '0700',
      require => Class['rsync'],
   }
}
