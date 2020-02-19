define samba::accountserver::config::tool($toolName = $title) {

   file {"samba_tool_$toolName":
      path => "/usr/bin/$toolName",
      ensure => file,
      source => "puppet:///modules/samba/$toolName",
      mode => '0744',
   }
}


#define samba::accountserver::config::server_redirection($servername = $title, $base_share) {
#
#   if $servername != $::hostname {
#      nfs::server::nfs4redirection { "$base_share/$servername":
#         target_host => $servername,
#         target_share => "$base_share/$servername",
#      }
#   }
#}


class samba::accountserver::config (
   $domain,
   $short_domain,
   $base_uid,
   $base_gid,
   $accountsrv_dns,
   $account_servers,
   $etc_path,
   $private_path,
   $base_dn,
   $users_ou,
   $shares_ou,
   $students_ou,
   $teachers_ou,
   $users_group,
   $shares_group,
   $students_group,
   $teachers_group,
   $class_supervisor_suffix,
   $dfs_path,
   $home_redirections,
   $profile_redirections,
   $home_path,
   $home_share,
   $profile_path,
   $profile_share,
   $share_path,
   $share_share,
   $students_dir,
   $teachers_dir,
   $teachers_common_dir,
   $common_dir,
   $resource_dir,
   $shared_dir,
   $test_dir,
   $home_drive, 
   $common_drive,
   $login_min_length,
   $login_surname_length,
   $login_givenname_length,
   $quota_mount_point,
   $quota_student_soft,
   $quota_student_hard,
   $quota_teacher_soft,
   $quota_teacher_hard
) {

   ############
   # install  #
   ############

   # for perl scripts #
   package { ['libstring-random-perl','libxml-libxml-simple-perl','libtext-unidecode-perl']:
      ensure => installed,
   }

   # the s4 tools #
   samba::accountserver::config::tool { ['s4classadd','s4groupadd','s4ldbsearch','s4makeshareddirs',
                            's4schoolsetup','s4sconetupdate','s4shareadd','s4studentadd',
                            's4studentclassadd','s4teacheradd','s4useradd','s4changepassword',
                            's4userdel','s4studentdel','s4teacherdel','s4usermove','s4studentmove',
                            's4classcheck','s4classdel','s4groupdel','s4sharedel']: }

   ####################
   # base directories #
   ####################

   # create dfs directory #
   exec { 'make_accounts_dfs_dir':
      command => "mkdir -p $dfs_path",
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "$dfs_path",
   }

   # create home directory #
   exec { 'make_accounts_home_dir':
      command => "mkdir -p $home_path",
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "$home_path",
   }

   # create profile directory #
   exec { 'make_accounts_profile_dir':
      command => "mkdir -p $profile_path",
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "$profile_path",
   }

   # create share directory #
   exec { 'make_accounts_share_dir':
      command => "mkdir -p $share_path",
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "$share_path",
   }

   ##########
   # config #
   ##########

   file { 's4.conf':
      path => "$etc_path/s4.conf",
      ensure => file,
      content => template('samba/s4.conf.erb'),
      mode => '0644',
   }

   file_option { 'netbios_account_alternate_name':
      path => '/etc/samba/smb.conf',
      option => 'netbios aliases',
      value => "${accountsrv_dns} ${accountsrv_dns}.${domain}",
      after => '\[global\]',
      multiple => false,
      ensure => present,
   }

   file_option { 'include_s4_shares.conf':
      path => "$etc_path/smb.conf",
      option => 'include',
      value => "$etc_path/s4_shares.conf",
      ensure => present,
      multiple => true,
   }

   file { 's4_shares.conf':
      path => "$etc_path/s4_shares.conf",
      ensure => file,
      content => template('samba/s4_shares.conf.erb'),
      mode => '0644',
   }

   ####################
   # export with nfs4 #
   ####################

   # create root #
   include nfs::server


   # local home share #
   nfs::server::nfs4export { "$home_path":
      share => "/$home_share/${::hostname}",
   }
  
   # redirect remote homes #
   #samba::accountserver::config::server_redirection { $account_servers:
   #   base_share => "/$home_share",
   #}
 
   #######
   # dns #
   #######
   # !! useless to update !! #
   # samba will be restarted #
   samba::srvregister { $accountsrv_dns:
      ensure => present,
      update => false,
   }
}

