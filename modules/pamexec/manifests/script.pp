define pamexec::script( $source = undef, $content = undef, $ensure = present ) {

   file { "/etc/pam_user_session_exec.d/$name":
      ensure => $ensure,
      source => $source,
      content => $content,
      mode => '0755',
      require => Class[pamexec::config],
   }

}   
      


