class shutdown (
   $hour = $shutdown::params::hour,
   $minute = $shutdown::params::minute,
   $delay = $shutdown::params::delay,
   $message = $shutdown::params::message
) inherits shutdown::params {

   # since suspend shutdown is useless #
   if $hour and $minute {

      cron { 'client_daily_shutdown':
         command => "/sbin/shutdown -h +${delay} \"${message}\"",
         user    => root,
         hour    => $hour,
         minute  => $minute,
         ensure => absent,
      }

   } else {

      cron { 'client_daily_shutdown':
         command => "/sbin/shutdown -h +${delay} \"${message}\"",
         user    => root,
         ensure => absent,
      }
   }
}
