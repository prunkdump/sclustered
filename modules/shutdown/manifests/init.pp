class shutdown (
   $hour = $shutdown::params::hour,
   $minute = $shutdown::params::minute,
   $delay = $shutdown::params::delay,
   $message = $shutdown::params::message
) inherits shutdown::params {

   if $hour and $minute {

      cron { 'client_daily_shutdown':
         command => "/sbin/shutdown -h +${delay} \"${message}\"",
         user    => root,
         hour    => $hour,
         minute  => $minute,
         ensure => present,
      }

   } else {

      cron { 'client_daily_shutdown':
         command => "/sbin/shutdown -h +${delay} \"${message}\"",
         user    => root,
         ensure => absent,
      }
   }
}
