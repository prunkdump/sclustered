class nfs (
   $translations = $nfs::params::translations,
   $enable_cachefilesd = $nfs::params::enable_cachefilesd,
   $root_path = $nfs::params::root_path,
   $network = $nfs::params::network,
   $home_share = $nfs::params::home_share,
   $home_server = $nfs::params::home_server,
   $daemon_count = $nfs::params::daemon_count,
   $export_options = $nfs::params::export_options,
   $nfs4_export_options = $nfs::params::nfs4_export_options,
   $mount_options = $nfs::params::mount_options,
   $nfs4_mount_options = $nfs::params::nfs4_mount_options
) inherits nfs::params {

   ###############################
   # nfs common to client/server #
   ###############################

   anchor { 'nfs::begin': } ->
   class { 'nfs::install': } ->
   class { 'nfs::config': } ~>
   class { 'nfs::service': } ->
   anchor { 'nfs::end': }

}
