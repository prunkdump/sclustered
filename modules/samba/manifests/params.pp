class samba::params {

   include network

   # enable/disable #
   $bind_module = winbind 
   $disable_nss = false
   $disable_pam = false
   $disable_groups = false
   $default_groups = []
   $account_server = false
   $accountsrv_dns = 'sambaaccount'
   $account_servers = []
   $print_server = false
   $sysvolrsyncsrv_dns = 'sysvolrsync' 
   $sysvolrsync_password = 'us@se!sd$ac'

   # network #
   $domain = 'samdom.com'
   $short_domain = 'SAMNET'
   $idmap_range = '3000000-9999999'
   $base_uid = '4000000'
   $base_gid = '5000000'
   $interfaces = ['lo','eth0']
   $default_admin_pass = 'SambaAdmin@4'
   $dns_forwarders = ["$::network::first_address"]
   $network = $::network::slashform
   $reverse_zone = $::network::reverse_zone
 
   # distribution setup #
   case $::osfamily {
      'Debian': {
         $adservice = 'samba-ad-dc'
         $nmbdservice = 'nmbd'
         $smbdservice = 'smbd'
         $winbindservice = 'winbind'
         $etc_path = '/etc/samba'
         $private_path = '/var/lib/samba/private'
         $binddlz_path = '/var/lib/samba/bind-dns'
         $sysvol_path = '/var/lib/samba/sysvol'
         $lib_path = $::architecture ? {
            'amd64' => '/usr/lib/x86_64-linux-gnu/samba',
            'i386' => '/usr/lib/i386-linux-gnu/samba',
            default => '/usr/lib/samba',
         }         
      }
      default: {
         fail("The ${module_name} is not supported on an ${::osfamily} distribution")
      }
   }

   # ldap structure #
   $users_ou = 'S4users'
   $shares_ou = 'S4shares'
   $students_ou = 'Students'
   $teachers_ou = 'Teachers'
 
   # group structure #
   $users_group = 's4users'
   $shares_group = 's4shares'
   $students_group = 'students'
   $teachers_group = 'teachers'
   $class_supervisor_suffix = 'supervisor'

   # server share directories #
   $dfs_path = '/srv/dfs'
   $redirector = 'localhost'
   $home_redirections = {}
   $profile_redirections = {}
   $home_path = '/home'
   $home_share = 'homes'
   $profile_path = '/profile'
   $profile_share = 'profiles'
   $share_path = '/share'
   $share_share = 'shares'
   $home_drive = 'H:'
   $common_drive = 'P:'
   $students_dir = 'Students'
   $teachers_dir = 'Teachers'
   $teachers_common_dir = 'Share'
   $common_dir = 'Common'
   $resource_dir = 'Resource'
   $shared_dir = 'Share'
   $test_dir = 'Tests'
   $common_mount_name = 'Common'

   # accounts parameters #
   $login_min_length = 2
   $login_surname_length =  7
   $login_givenname_length = 1

   # quota #
   $quota_mount_point = '/home'
   $quota_student_soft = '1Go'
   $quota_student_hard = '2Go'
   $quota_teacher_soft = '5Go'
   $quota_teacher_hard = '6Go'

   # main gpo #
   $maingpo_name = 'logonScript'
   $maingpo_id = '{5D552AD7-B6FC-4D69-989D-D710FB5D9643}'
   $maingpo_version = 262144

   #extensions
   #ProcessScriptsGroupPolicy and 
   #Scripts (Logon/Logoff) Run Restriction
   $maingpo_user_extensions = ['{42B5FAAE-6536-11D2-AE5A-0000F87571E3}',
                               '{40B66650-4972-11D1-A7CA-0000F87571E3}'] 
}
