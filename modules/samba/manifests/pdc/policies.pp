define samba::pdc::policies::policy::file ( $filepath = $title,
                                            $id,
                                            $params ) {


   # keep vars #
   $accountsrv_dns = $samba::pdc::accountsrv_dns
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
         mode => '0644',
      }

   } else {

      # create the src file #
      file { $absolute_src_file_path:
         ensure => file,
         content => template("samba/$source"),
         mode => '0644',
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
      mode => '0644',
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

   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $sysvol_path = $samba::pdc::sysvol_path
   $private_path = $samba::pdc::private_path
   $gpo_logon_script_name = $samba::pdc::gpo_logon_script_name
   $gpo_logon_script_id = $samba::pdc::gpo_logon_script_id
   $gpo_logon_script_version = $samba::pdc::gpo_logon_script_version
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


}
