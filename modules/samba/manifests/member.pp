class samba::member (
   $adservice = $samba::adservice,
   $bind_module = $samba::bind_module,
   #$umask = $samba::umask,
   $disable_nss = $samba::disable_nss,
   $disable_pam = $samba::disable_pam,
   $disable_groups = $samba::disable_groups,
   $default_groups = $samba::default_groups,
   $etc_path = $samba::etc_path,
) inherits samba {

   # get common vars #
   $realm = $samba::realm
   $short_domain = $samba::short_domain

   ###########
   # install #
   ###########
   anchor { 'samba::member::begin': } ->
   class { 'samba::member::install': }

   ##########
   # config #
   ##########
   class { 'samba::member::config':
      require => Class['samba::member::install'],
      notify => Class['samba::member::service'],
   }

   #####################
   # optionnal classes #
   #####################
   if $disable_nss == false {
      class { 'samba::nss':
         bind_module => $bind_module,
         require => Class['samba::member::install'],
         notify => Class['samba::member::service'],
      }
   }
   if $disable_pam == false {
      class { 'samba::pam':
         bind_module => $bind_module,
         #umask => $umask,
         require => Class['samba::member::install'],
         notify => Class['samba::member::service'],
      }
   }
   if $disable_groups == false {
      class { 'samba::pam_group':
         groups => $default_groups,
         require => Class['samba::member::install'],
         before => Class['samba::member::service'],
      }
   }


   ########################
   # launch service       #
   ########################
   class { 'samba::member::service': }->
   anchor { 'samba::member::end': }
}
