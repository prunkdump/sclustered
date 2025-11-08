define samba::pdc::policies::policy::file ( $filepath = $title,
                                            $id,
                                            $version = undef,
                                            $policy_name = undef,
                                            $params ) {


   # keep vars #
   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $home_share = $samba::pdc::home_share

   $http_enabled_proxy = $samba::pdc::policies::http_enabled_proxy
   $selected_account_redirector = $samba::pdc::policies::selected_account_redirector
   $sysvol_path = $samba::pdc::policies::sysvol_path
   $private_path = $samba::pdc::policies::private_path
   $base_dn = $samba::pdc::policies::base_dn
   $users_ou = $samba::pdc::policies::users_ou
   $shares_ou = $samba::pdc::policies::shares_ou
   $students_ou = $samba::pdc::policies::students_ou
   $teachers_ou = $samba::pdc::policies::teachers_ou
   $users_group = $samba::pdc::policies::users_group
   $shares_group = $samba::pdc::policies::shares_group
   $students_group = $samba::pdc::policies::students_group
   $teachers_group = $samba::pdc::policies::teachers_group
   $home_drive = $samba::pdc::policies::home_drive
   $common_drive = $samba::pdc::policies::common_drive
   $students_dir = $samba::pdc::policies::students_dir
   $teachers_dir = $samba::pdc::policies::teachers_dir
   $common_dir = $samba::pdc::policies::common_dir
   $realm = $samba::pdc::policies::realm
   $domain = $samba::pdc::policies::domain
   $reverse_zone = $samba::pdc::policies::reverse_zone
   $home_path = $samba::pdc::policies::home_path
   $profile_path = $samba::pdc::policies::profile_path

   # get params #
   $encoding = $params[$filepath][encoding]
   $source = $params[$filepath][source]

   # create absolute path #
   $absolute_file_path = "$sysvol_path/$domain/Policies/{$id}/$filepath"
   $absolute_src_file_path = "${absolute_file_path}.src"

   # if binary create the file directly #
   if ( $encoding == "binary" ) {

      # binary file #
      file { $absolute_file_path:
         ensure => file,
         source => "puppet:///modules/samba/$source",
         mode => '0770',
      }

   } else {

      # create the src file #
      file { $absolute_src_file_path:
         ensure => file,
         content => template("samba/$source"),
         mode => '0770',
      }

      # change encoding #
      exec { "unix2dos < '$absolute_src_file_path' | iconv -f UTF-8 -t $encoding > '$absolute_file_path'" :
         path => '/usr/bin:/usr/sbin:/bin',
         subscribe => File[$absolute_src_file_path],
         refreshonly => true,
      }
   }
}

   
define samba::pdc::policies::policy( $id,
                                     $version,
                                     $user_extensions = [],
                                     $machine_extensions = [],
                                     $directories = [],
                                     $files = {},
                                     $link_target ) {

   # keep vars #
   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $home_share = $samba::pdc::home_share

   $http_enabled_proxy = $samba::pdc::policies::http_enabled_proxy
   $selected_account_redirector = $samba::pdc::policies::selected_account_redirector
   $sysvol_path = $samba::pdc::policies::sysvol_path
   $private_path = $samba::pdc::policies::private_path
   $default_admin_pass = $samba::pdc::policies::default_admin_pass
   $base_dn = $samba::pdc::policies::base_dn
   $users_ou = $samba::pdc::policies::users_ou
   $shares_ou = $samba::pdc::policies::shares_ou
   $students_ou = $samba::pdc::policies::students_ou
   $teachers_ou = $samba::pdc::policies::teachers_ou
   $users_group = $samba::pdc::policies::users_group
   $shares_group = $samba::pdc::policies::shares_group
   $students_group = $samba::pdc::policies::students_group
   $teachers_group = $samba::pdc::policies::teachers_group
   $home_drive = $samba::pdc::policies::home_drive
   $common_drive = $samba::pdc::policies::common_drive
   $students_dir = $samba::pdc::policies::students_dir
   $teachers_dir = $samba::pdc::policies::teachers_dir
   $common_dir = $samba::pdc::policies::common_dir
   $realm = $samba::pdc::policies::realm
   $domain = $samba::pdc::policies::domain
   $reverse_zone = $samba::pdc::policies::reverse_zone
   $home_path = $samba::pdc::policies::home_path
   $profile_path = $samba::pdc::policies::profile_path



   # compute base path #
   $base_path = "$sysvol_path/$domain/Policies/{$id}"

   # create directories #
   $directories_path = prefix($directories, "$base_path/");

   file { $base_path:
      ensure => directory,
   }

   file { $directories_path:
      ensure => directory,
      require => File[$base_path],
   }

   # create GPT.INI #
   samba::pdc::policies::policy::file { "$base_path/GPT.INI":
      filepath => "GPT.INI",
      id => $id,
      version => $version,
      policy_name => $name,
      params => { 'GPT.INI' => { source => 'GPT.INI.erb', encoding => 'CP1252' } },
      require => File[$directories_path],
   }

   # create files #
   samba::pdc::policies::policy::file { keys($files):
      id => $id,
      params => $files,
      require => File[$directories_path],
   }

   # generate ldif #
   file { "$base_path/setup.ldif":
      ensure => file,
      content => template("samba/policy_install.erb"),
      mode => '0770',
   }

   # install gpo #
   exec { "ldbmodify -H '$private_path/sam.ldb' '$base_path/setup.ldif' ":
      path => '/usr/bin:/usr/sbin:/bin',
      subscribe => File["$base_path/setup.ldif"],
      refreshonly => true,
   }

   # link gpo #
   exec { "samba-tool gpo setlink '$link_target,$base_dn' '{$id}' -Uadministrator --password=$default_admin_pass && samba-tool ntacl sysvolreset -Uadministrator --password=$default_admin_pass":
      path => '/usr/bin:/usr/sbin:/bin',
      subscribe => File["$base_path/setup.ldif"],
      refreshonly => true,
   }

}


class samba::pdc::policies {

   # check account redirector #
   $account_redirector = $samba::pdc::account_redirector

   if ! $account_redirector {
      $selected_account_redirector = $::hostname
   } else {
      $selected_account_redirector = $account_redirector
   }

   # check proxy #
   include network

   $http_proxy = $::network::http_proxy
   $https_proxy = $::network::https_proxy

   if $http_proxy {
      $http_enabled_proxy = $http_proxy
   } elsif $https_proxy {
      $http_enabled_proxy = $https_proxy
   } else {
      $http_enabled_proxy = undef
   }

   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $home_share = $samba::pdc::home_share
   $sysvol_path = $samba::pdc::sysvol_path
   $private_path = $samba::pdc::private_path
   $gpo_logon_script_name = $samba::pdc::gpo_logon_script_name
   $gpo_logon_script_id = $samba::pdc::gpo_logon_script_id
   $gpo_logon_script_version = $samba::pdc::gpo_logon_script_version
   $gpo_logon_scriptsync_name = $samba::pdc::gpo_logon_scriptsync_name
   $gpo_logon_scriptsync_id = $samba::pdc::gpo_logon_scriptsync_id
   $gpo_logon_scriptsync_version = $samba::pdc::gpo_logon_scriptsync_version
   $gpo_folder_redirection_name = $samba::pdc::gpo_folder_redirection_name
   $gpo_folder_redirection_id = $samba::pdc::gpo_folder_redirection_id
   $gpo_folder_redirection_version = $samba::pdc::gpo_folder_redirection_version
   $gpo_proxy_settings_name = $samba::pdc::gpo_proxy_settings_name
   $gpo_proxy_settings_id = $samba::pdc::gpo_proxy_settings_id
   $gpo_proxy_settings_version = $samba::pdc::gpo_proxy_settings_version


   $default_admin_pass = $samba::pdc::default_admin_pass
   $base_dn = $samba::pdc::base_dn
   $users_ou = $samba::pdc::users_ou
   $shares_ou = $samba::pdc::shares_ou
   $students_ou = $samba::pdc::students_ou
   $teachers_ou = $samba::pdc::teachers_ou
   $users_group = $samba::pdc::users_group
   $shares_group = $samba::pdc::shares_group
   $students_group = $samba::pdc::students_group
   $teachers_group = $samba::pdc::teachers_group
   $home_drive = $samba::pdc::home_drive
   $common_drive = $samba::pdc::common_drive
   $students_dir = $samba::pdc::students_dir
   $teachers_dir = $samba::pdc::teachers_dir
   $common_dir = $samba::pdc::common_dir
   $realm = $samba::pdc::realm
   $domain = $samba::pdc::domain
   $reverse_zone = $samba::pdc::reverse_zone
   $home_path = $samba::pdc::home_path
   $profile_path = $samba::pdc::profile_path

   # logon, logoff script GPO #
   samba::pdc::policies::policy { $gpo_logon_script_name:
      id => $gpo_logon_script_id,
      version => $gpo_logon_script_version,
      user_extensions => ['42B5FAAE-6536-11D2-AE5A-0000F87571E3','40B66650-4972-11D1-A7CA-0000F87571E3'],
      machine_extensions => [],
      directories => ['Machine',
                      'User',
                      'User/Documents & Settings',
                      'User/Applications',
                      'User/Scripts',
                      'User/Scripts/Logon',
                      'User/Scripts/Logoff'
                     ],
      files => { 'User/Scripts/scripts.ini' => { source => 'gpo_script_scripts.ini.erb',
                                                 encoding => 'UTF-16'} ,
                 'User/Scripts/psscripts.ini' => { source => 'gpo_script_psscripts.ini.erb',
                                                   encoding => 'UTF-16' } ,
                 'User/Scripts/Logon/connect.vbs' => { source => 'gpo_script_connect.vbs.erb',
                                                       encoding => 'CP1252' },
                 'User/Scripts/Logoff/logout.vbs' => { source => 'gpo_script_logout.vbs.erb',
                                                       encoding => 'CP1252' },
               },
       link_target => "OU=$users_ou",
   }

   # logon script sync #
   samba::pdc::policies::policy { $gpo_logon_scriptsync_name:
      id => $gpo_logon_scriptsync_id,
      version => $gpo_logon_scriptsync_version,
      user_extensions => ['35378EAC-683F-11D2-A89A-00C04FBBCFA2','D02B1F73-3407-48AE-BA88-E8213C6761F1'],
      machine_extensions => [],
      directories => ['Machine',
                      'User',
                     ],
      files => { 'User/comment.cmtx' => { source => 'gpo_scriptsync_comment.cmtx',
                                                 encoding => 'binary'} ,
                 'User/Registry.pol' => { source => 'gpo_scriptsync_Registry.pol',
                                                 encoding => 'binary' } ,
               },
      link_target => "OU=$users_ou",
   }


   # folder redirection #
   samba::pdc::policies::policy { $gpo_folder_redirection_name:
      id => $gpo_folder_redirection_id,
      version => $gpo_folder_redirection_version,
      user_extensions => ['25537BA6-77A8-11D2-9B6C-0000F8080861','88E729D6-BDC1-11D1-BD2A-00C04FB9603F'],
      machine_extensions => [],
      directories => ['Machine',
                      'User',
                      'User/Documents & Settings',
                      'User/Scripts',
                      'User/Scripts/Logon',
                      'User/Scripts/Logoff',
                     ],
      files => { 'User/Documents & Settings/fdeploy.ini' => { source => 'gpo_folderredirection_fdeploy.ini.erb',
                                                              encoding => 'UTF-16' },
                 'User/Documents & Settings/fdeploy1.ini' => { source => 'gpo_folderredirection_fdeploy1.ini.erb',
                                                              encoding => 'UTF-16' },
               },
      link_target => "OU=$users_ou",
   }


   # proxy #
   if $http_proxy or $https_proxy {

      samba::pdc::policies::policy { $gpo_proxy_settings_name:
         id => $gpo_proxy_settings_id,
         version => $gpo_proxy_settings_version,
         user_extensions => ['00000000-0000-0000-0000-000000000000','5C935941-A954-4F7C-B507-885941ECE5C4','E47248BA-94CC-49C4-BBB5-9EB7F05183D0','5C935941-A954-4F7C-B507-885941ECE5C4'],
         machine_extensions => [],
         directories => ['Machine',
                         'User',
                         'User/Preferences',
                         'User/Preferences/InternetSettings',
                         'User/Documents & Settings',
                         'User/Scripts',
                         'User/Scripts/Logon',
                         'User/Scripts/Logoff'
                        ],
         files => { 'User/Preferences/InternetSettings/InternetSettings.xml' => { source => 'gpo_proxysettings_InternetSettings.xml.erb',
                                                                                  encoding => 'UTF-8' },
                  },
         link_target => "OU=$users_ou",
      }
   }
}
