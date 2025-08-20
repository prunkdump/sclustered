define rsync::replicate (
   $server,
   $password,
   $src_files,
   $dest_path,
   $second = '*',
   $minute = '*',
   $hour = '*',
   $year = '*',
   $month = '*',
   $monthday = '*',
   $weekday = undef,
   $randomize = undef,
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


   #################
   # replicate job #
   #################
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


   # disable replicate by cron        #
   # as all requests are launched     #
   # exactly at the same time         #
   # added randomize parameter with   #
   # systemd                          #
   cron { "${name}_rsync_replicate":
      ensure => absent,
      command => $replicate_rsync_command,
      user => root,
      require => File["/var/lib/rsync/rsync-${name}.secret"],
   }

   if $weekday {
      $weekdayPart = "$weekday "
   } else {
      $weekdayPart = ""
   }

   systemdjob { "${name}_rsync_replicate_job":
      ensure => present,
      script => "#! /bin/bash\n$replicate_rsync_command",
      trigger => "OnCalendar=${weekdayPart}$year-$month-$monthday $hour:$minute:$second",
      description => "${name} Rsync replication job",
      randomize => $randomize,
      require => File["/var/lib/rsync/rsync-${name}.secret"],
   }

   # to manually replicate #
   file { "/usr/sbin/replicate-${name}":
      ensure => file,
      content => "#! /bin/bash\n$replicate_rsync_command",
      mode => '0700',
      require => Class['rsync'],
   }
}
