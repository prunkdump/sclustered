class samba::pdc (
   $bind_module = $samba::bind_module,
   $disable_nss = $samba::disable_nss,
   $disable_pam = $samba::disable_pam,
   $disable_groups = $samba::disable_groups,
   $default_groups = $samba::default_groups,
   $account_server = $samba::account_server,
   $rsync_sysvol = $samba::rsync_sysvol,
   $print_server = $samba::print_server,
   $interfaces = $samba::interfaces,
   $default_admin_pass = $samba::default_admin_pass,
   $dns_forwarders = $samba::dns_forwarders,
   $adservice = $samba::adservice,
   $nmbdservice = $samba::nmbdservice,
   $smbdservice = $samba::smbdservice,
   $winbindservice = $samba::winbindservice,
   $etc_path = $samba::etc_path,
   $private_path = $samba::private_path,
   $binddlz_path = $samba::binddlz_path,
   $lib_path = $samba::lib_path,
   $sysvol_path = $samba::sysvol_path,
   $dfs_path = $samba::dfs_path,
   $redirector = $samba::redirector,
   $home_redirections = $samba::home_redirections,
   $profile_redirections = $samba::profile_redirections,
   $home_path = $samba::home_path,
   $profile_path = $samba::profile_path,
   $share_path = $samba::share_path,
   $quota_mount_point = $samba::quota_mount_point
) inherits samba {

   # get common vars #
   $accountsrv_dns = $samba::accountsrv_dns
   $account_servers = $samba::account_servers
   $sysvolrsyncsrv_dns = $samba::sysvolrsyncsrv_dns
   $sysvolrsync_password = $samba::sysvolrsync_password
   $realm = $samba::realm
   $domain = $samba::domain
   $short_domain = $samba::short_domain
   $base_uid = $samba::base_uid
   $base_gid = $samba::base_gid
   $network = $samba::network
   $reverse_zone = $samba::reverse_zone
   $base_dn = $samba::base_dn
   $users_ou = $samba::users_ou
   $shares_ou = $samba::shares_ou
   $students_ou = $samba::students_ou
   $teachers_ou = $samba::teachers_ou
   $users_group = $samba::users_group
   $shares_group = $samba::shares_group
   $students_group = $samba::students_group
   $teachers_group = $samba::teachers_group
   $class_supervisor_suffix = $samba::class_supervisor_suffix
   $home_share = $samba::home_share
   $profile_share = $samba::profile_share
   $share_share = $samba::share_share
   $home_drive = $samba::home_drive
   $common_drive = $samba::common_drive
   $students_dir = $samba::students_dir
   $teachers_dir = $samba::teachers_dir
   $teachers_common_dir = $samba::teachers_common_dir
   $common_dir = $samba::common_dir
   $resource_dir = $samba::resource_dir
   $shared_dir = $samba::shared_dir
   $test_dir = $samba::test_dir
   $login_min_length = $samba::login_min_length
   $login_surname_length = $samba::login_surname_length
   $login_givenname_length = $samba::login_givenname_length
   $quota_student_soft = $samba::quota_student_soft
   $quota_student_hard = $samba::quota_student_hard
   $quota_teacher_soft = $samba::quota_teacher_soft
   $quota_teacher_hard = $samba::quota_teacher_hard
   $maingpo_name = $samba::maingpo_name
   $maingpo_id = $samba::maingpo_id
   $maingpo_version = $samba::maingpo_version
   $maingpo_user_extensions = $samba::maingpo_user_extensions

   ######################
   # samba/bind install #
   ######################
   anchor { 'samba::pdc::begin': } ->
   class { 'samba::pdc::install': } -> 
   class { 'samba::bind_setup':
      domain => $domain,
      network => $network,
      dns_forwarders => $dns_forwarders,
      binddlz_path => $binddlz_path,
      lib_path => $lib_path,
      before => Class['samba::dcservice'],
   }

   #####################
   # optionnal classes #
   #####################
   if $disable_nss == false {
      class { 'samba::nss':
         bind_module => $bind_module,
         require => Class['samba::bind_setup'],
         notify => Class['samba::dcservice'],
      }
   }
   # doesn't works on dc 
   #if $disable_pam == false {
   #   class { 'samba::pam':
   #      bind_module => $bind_module,
   #      require => Class['samba::bind_setup'],
   #      notify => Class['samba::dcservice'],
   #   }
   #}
   if $disable_groups == false {
      class { 'samba::pam_group' :
         groups => $default_groups,
         require => Class['samba::bind_setup'],
         notify => Class['samba::dcservice'],
      }
   }
   if $account_server == true {
      class { 'samba::accountserver::config':
         domain => $domain,
         short_domain => $short_domain,
         base_uid => $base_uid,
         base_gid => $base_gid,
         accountsrv_dns => $accountsrv_dns,
         account_servers => $account_servers,
         etc_path => $etc_path,
         private_path => $private_path,
         base_dn => $base_dn,
         users_ou => $users_ou,
         shares_ou => $shares_ou,
         students_ou => $students_ou,
         teachers_ou => $teachers_ou,
         users_group => $users_group,
         shares_group => $shares_group,
         students_group => $students_group,
         teachers_group => $teachers_group,
         class_supervisor_suffix => $class_supervisor_suffix,
	 dfs_path => $dfs_path,
	 home_redirections => $home_redirections,
	 profile_redirections => $profile_redirections,
         home_path => $home_path,
         home_share => $home_share,
         profile_path => $profile_path,
         profile_share => $profile_share,
         share_path => $share_path,
         share_share => $share_share,
         students_dir => $students_dir,
         teachers_dir => $teachers_dir,
         teachers_common_dir => $teachers_common_dir,
         common_dir => $common_dir,
         resource_dir => $resource_dir,
         shared_dir => $shared_dir,
         test_dir => $test_dir,
         home_drive => $home_drive,
         common_drive => $common_drive,
         login_min_length => $login_min_length,
         login_surname_length => $login_surname_length,
         login_givenname_length => $login_givenname_length,
         quota_mount_point => $quota_mount_point,
         quota_student_soft => $quota_student_soft,
         quota_student_hard => $quota_student_hard,
         quota_teacher_soft => $quota_teacher_soft,
         quota_teacher_hard => $quota_teacher_hard,
         require => Class['samba::bind_setup'],
         notify => Class['samba::dcservice'],
      }
   }
   if $print_server == true {
      class { 'samba::printserver::config':
         etc_path => $etc_path,
         require => Class['samba::bind_setup'],
         notify => Class['samba::dcservice'],
      }
   }


   ########################
   # launch service       #
   # and make post config #
   ########################
   class { 'samba::dcservice':
      adservice => $adservice,
      disable_nss => $disable_nss,
      disable_pam => $disable_pam,
   }
   if $rsync_sysvol != true {
      class { 'samba::pdc::postconfig':
         require => Class['samba::dcservice'],
         before => Anchor['samba::pdc::end'],
      }
   }
   class { 'samba::pdc::sysvolrsync':
      rsync_sysvol => $rsync_sysvol,
      require => Class['samba::dcservice'],
      before => Anchor['samba::pdc::end'],
   }
   if $print_server == true {
      class { 'samba::printserver::postconfig':
         adservice => $adservice,
         short_domain => $short_domain,
         require => Class['samba::pdc::sysvolrsync'],
         before => Anchor['samba::pdc::end'],
      }
   }
   if $account_server == true {
      class { 'samba::accountserver::postconfig':
         adservice => $adservice,
         profile_path => $profile_path,
         short_domain => $short_domain,
         users_group =>  $users_group,
         require => Class['samba::pdc::sysvolrsync'],
         before => Anchor['samba::pdc::end'],
      }
   }
   anchor { 'samba::pdc::end': }
}
