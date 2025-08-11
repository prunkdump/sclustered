class pamexec::install {

   # install pam_exec pam profile #
   file { '/usr/share/pam-configs/exec-session':
      ensure  => file,
      source => "puppet:///modules/pamexec/exec-session",
      mode => '0644',
   }

   # execute pam-auth-update #
   exec { 'pam-auth-update --force':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      subscribe => File['/usr/share/pam-configs/exec-session'],
      refreshonly => true,
   }

   # install scripts loaders #
   file { '/usr/sbin/pam_exec_session.sh':
      ensure  => file,
      source => "puppet:///modules/pamexec/pam_exec_session.sh",
      mode => '0755',
   }

   file { '/usr/bin/pam_user_exec_session.sh':
      ensure  => file,
      source => "puppet:///modules/pamexec/pam_user_exec_session.sh",
      mode => '0755',
   }

}
