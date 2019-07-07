class nfs::client (
   $home_server = $nfs::home_server,
   $enable_cachefilesd = $nfs::enable_cachefilesd,
   $mount_options = $nfs::mount_options,
   $nfs4_mount_options = $nfs::nfs4_mount_options
) inherits nfs {

   # get common internal vars #
   $home_share = $nfs::home_share
   
   # get common external vars #
   include samba
   $samba_domain = $::samba::domain
   $samba_share_share = $::samba::share_share
   $samba_users_group = $::samba::users_group
   $samba_students_group = $::samba::students_group
   $samba_teachers_group = $::samba::teachers_group
   $samba_students_dir = $::samba::students_dir
   $samba_common_dir = $::samba::common_dir
   $samba_common_mount_name = $::samba::common_mount_name


   ##########
   # client #
   ##########
   anchor { 'nfs::client::begin': } ->
   class { 'nfs::client::install': } ->
   class { 'nfs::client::config': } ~>
   class { 'nfs::client::service': } ->
   anchor { 'nfs::client::end': }

}
      
