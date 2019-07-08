class samba::accountserver::postconfig(
   $adservice,
   $profile_path,
   $short_domain,
   $users_group
) {

   # "domain users" is mapped to the "users" group
   file { "$profile_path":
      ensure => directory,
      owner => root,
      group => "users",
      mode => '1750',
      require => Service[$adservice],
   }
}
