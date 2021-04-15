class samba (
   $bind_module = $samba::params::bind_module,
   $disable_nss = $samba::params::disable_nss,
   $disable_pam = $samba::params::disable_pam,
   $disable_groups = $samba::params::disable_groups,
   $default_groups = $samba::params::default_groups,
   $account_server = $samba::params::account_server,
   $account_redirector = $samba::params::account_redirector,
   $rsync_sysvol = $samba::params::rsync_sysvol,
   $accountsrv_dns = $samba::params::accountsrv_dns,
   $accountsrv_cron_time = samba::params::accountsrv_cron_time,
   $print_server = $samba::params::print_server,
   $sysvolrsyncsrv_dns = $samba::params::sysvolrsyncsrv_dns,
   $sysvolrsync_password = $samba::params::sysvolrsync_password,
   $domain = $samba::params::domain,
   $short_domain = $samba::params::short_domain,
   $idmap_range = $samba::params::idmap_range,
   $base_uid = $samba::params::base_uid,
   $base_gid = $samba::params::base_gid,
   $interfaces = $samba::params::interfaces,
   $default_admin_pass = $samba::params::default_admin_pass,
   $dns_forwarders = $samba::params::dns_forwarders,
   $network = $samba::params::network,
   $reverse_zone = $samba::params::reverse_zone,
   $adservice = $samba::params::adservice,
   $nmbdservice = $samba::params::nmbdservice,
   $smbdservice = $samba::params::smbdservice,
   $winbindservice = $samba::params::winbindservice,
   $etc_path = $samba::params::etc_path,
   $private_path = $samba::params::private_path,
   $binddlz_path = $samba::params::binddlz_path,
   $lib_path = $samba::params::lib_path,
   $sysvol_path = $samba::params::sysvol_path,
   $users_ou = $samba::params::users_ou,
   $shares_ou = $samba::params::shares_ou,
   $students_ou = $samba::params::students_ou,
   $teachers_ou = $samba::params::teachers_ou,
   $users_group = $samba::params::users_group,
   $shares_group = $samba::params::shares_group,
   $students_group = $samba::params::students_group,
   $teachers_group = $samba::params::teachers_group,
   $class_supervisor_suffix = $samba::params::class_supervisor_suffix,
   $dfs_path = $samba::params::dfs_path,
   $redirector = $samba::params::redirector,
   $home_redirections = $samba::params::home_redirections,
   $profile_redirections = $samba::params::profile_redirections,
   $home_path = $samba::params::home_path,
   $home_share = $samba::params::home_share,
   $profile_path = $samba::params::profile_path,
   $profile_share = $samba::params::profile_share,
   $share_path = $samba::params::share_path,
   $share_share = $samba::params::share_share,
   $home_drive = $samba::params::home_drive,
   $common_drive = $samba::params::common_drive,
   $students_dir = $samba::params::students_dir,
   $teachers_dir = $samba::params::teachers_dir,
   $teachers_common_dir = $samba::params::teachers_common_dir,
   $common_dir = $samba::params::common_dir,
   $resource_dir = $samba::params::resource_dir, 
   $shared_dir = $samba::params::shared_dir,
   $test_dir = $samba::params::test_dir,
   $common_mount_name = $samba::params::common_mount_name,
   $login_min_length = $samba::params::login_min_length,
   $login_surname_length = $samba::params::login_surname_length,
   $login_givenname_length = $samba::params::login_givenname_length,
   $quota_mount_point = $samba::params::quota_mount_point,
   $quota_student_soft = $samba::params::quota_student_soft,
   $quota_student_hard = $samba::params::quota_student_hard,
   $quota_teacher_soft = $samba::params::quota_teacher_soft,
   $quota_teacher_hard = $samba::params::quota_teacher_hard,
   $maingpo_name = $samba::params::maingpo_name,
   $maingpo_id = $samba::params::maingpo_id,
   $maingpo_version = $samba::params::maingpo_version,
   $maingpo_user_extensions = $samba::params::maingpo_user_extensions

) inherits samba::params {

   ########################
   # computed common vars #
   ########################

   # realm #
   $realm = upcase($domain)

   # base_dn #
   $base_dn_suffix = regsubst($domain, '\.', ',DC=', 'G')
   $base_dn = "DC=${base_dn_suffix}" 

}
