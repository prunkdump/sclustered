class samba::pdc::postconfig {
   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $sysvol_path = $samba::pdc::sysvol_path
   $private_path = $samba::pdc::private_path
   $maingpo_name = $samba::pdc::maingpo_name
   $maingpo_id = $samba::pdc::maingpo_id
   $maingpo_version = $samba::pdc::maingpo_version
   $maingpo_user_extensions = $samba::pdc::maingpo_user_extensions
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

   ###################
   # deploy main gpo #
   ###################

   # gpo directories #
   file { ["$sysvol_path/$domain/Policies/$maingpo_id",
           "$sysvol_path/$domain/Policies/$maingpo_id/Machine",
           "$sysvol_path/$domain/Policies/$maingpo_id/User",
           "$sysvol_path/$domain/Policies/$maingpo_id/User/Applications",
           "$sysvol_path/$domain/Policies/$maingpo_id/User/Documents & Settings",
           "$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts",
           "$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logoff",
           "$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logon"] :
      ensure => directory,
   }
           
   # create gpo #
   file { "$private_path/maingpo" :
      ensure => directory,
   }

   package { 'dos2unix':
      ensure =>installed,
   }

   # GPT.ini #
   file { "$private_path/maingpo/GPT.INI":
      ensure => file,
      content => template('samba/GPT.INI.erb'),
      mode => '0644',
      require => File["$private_path/maingpo"],
   }

   exec { "unix2dos < $private_path/maingpo/GPT.INI | iconv -f UTF-8 -t CP1252 > $sysvol_path/$domain/Policies/$maingpo_id/GPT.INI" :
      path => '/usr/bin:/usr/sbin:/bin',
      require => [File["$sysvol_path/$domain/Policies/$maingpo_id"],Package['dos2unix']],
      subscribe => File["$private_path/maingpo/GPT.INI"],
      refreshonly => true,
   }

   # scripts.ini #
   file { "$private_path/maingpo/scripts.ini":
      ensure => file,
      content => template('samba/scripts.ini.erb'),
      mode => '0644',
      require => File["$private_path/maingpo"],
   }

   exec { "unix2dos < $private_path/maingpo/scripts.ini | iconv -f UTF-8 -t UTF-16 > $sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/scripts.ini" :
      path => '/usr/bin:/usr/sbin:/bin',
      require => [File["$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts"],Package['dos2unix']],
      subscribe => File["$private_path/maingpo/scripts.ini"],
      refreshonly => true,
   }

   # psscripts.ini #
   file { "$private_path/maingpo/psscripts.ini":
      ensure => file,
      content => template('samba/psscripts.ini.erb'),
      mode => '0644',
      require => File["$private_path/maingpo"],
   }

   exec { "unix2dos < $private_path/maingpo/psscripts.ini | iconv -f UTF-8 -t UTF-16 > $sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/psscripts.ini" :
      path => '/usr/bin:/usr/sbin:/bin',
      require => [File["$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts"],Package['dos2unix']],
      subscribe => File["$private_path/maingpo/psscripts.ini"],
      refreshonly => true,
   }

   # connect.vbs #
   file { "$private_path/maingpo/connect.vbs":
      ensure => file,
      content => template('samba/connect.vbs.erb'),
      mode => '0644',
      require => File["$private_path/maingpo"],
   }

   exec { "unix2dos < $private_path/maingpo/connect.vbs | iconv -f UTF-8 -t CP1252 > $sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logon/connect.vbs" :
      path => '/usr/bin:/usr/sbin:/bin',
      require => [File["$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logon"],Package['dos2unix']],
      subscribe => File["$private_path/maingpo/connect.vbs"],
      refreshonly => true,
   }

   # logout.vbs #
   file { "$private_path/maingpo/logout.vbs":
      ensure => file,
      content => template('samba/logout.vbs.erb'),
      mode => '0644',
      require => File["$private_path/maingpo"],
   }

   exec { "unix2dos < $private_path/maingpo/logout.vbs | iconv -f UTF-8 -t CP1252 > $sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logoff/logout.vbs" :
      path => '/usr/bin:/usr/sbin:/bin',
      require => [File["$sysvol_path/$domain/Policies/$maingpo_id/User/Scripts/Logoff"],Package['dos2unix']],
      subscribe => File["$private_path/maingpo/logout.vbs"],
      refreshonly => true,
   }

   ############################
   # samba main configuration #
   ############################

   # use to reverse dns update #
   # !! made in the samba script !! #
   $split_ip = split($::ipaddress, '[.]')
   $host_reverse_entry = "${split_ip[3]}.${split_ip[2]}.${split_ip[1]}.${split_ip[0]}.in-addr.arpa"   

   file { "$private_path/samba_conf.sh":
      ensure => file,
      content => template('samba/samba_conf.sh.erb'),
      mode => '0700',
   }

   exec { "$private_path/samba_conf.sh $default_admin_pass":
      require => File['/etc/krb5.conf'],
      subscribe => File["$private_path/samba_conf.sh"],
      refreshonly => true,
   }
}
