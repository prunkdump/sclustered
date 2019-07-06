class samba::accountserver::postconfig(
   $adservice,
   $profile_path,
   $short_domain,
   $users_group
) {

   file { "$profile_path":
      ensure => directory,
      owner => root,
      group => "$short_domain\\Domain Users",
      mode => '1750',
      require => Service[$adservice],
   }
}
