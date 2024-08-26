class samba::pdc::postconfig {
   $accountsrv_dns = $samba::pdc::accountsrv_dns
   $sysvol_path = $samba::pdc::sysvol_path
   $private_path = $samba::pdc::private_path
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
