class pamexec::config {

   file { '/etc/pam_user_session_exec.d':
      ensure => directory,
   }

}
