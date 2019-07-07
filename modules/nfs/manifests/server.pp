class nfs::server (
   $root_path = $nfs::root_path,
   $network = $nfs::network,
   $daemon_count = $nfs::daemon_count,
   $export_options = $nfs::export_options,
   $nfs4_export_options = $nfs::nfs4_export_options,
   $mount_options = $nfs::mount_options,
   $nfs4_mount_options = $nfs::nfs4_mount_options
) inherits nfs {

   # get common internal vars # 
   $home_share = $nfs::home_share

   ##########
   # server #
   ##########
   anchor { 'nfs::server::begin': } ->
   class { 'nfs::server::install': } ->
   class { 'nfs::server::config': } ~>
   class { 'nfs::server::service': } ->
   anchor { 'nfs::server::end': } 
}
