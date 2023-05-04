class puppet::camaster (
   $compiler_only = $puppet::compiler_only,
   $enable_fai = $puppet::enable_fai,
   $fai_static_params = $puppet::fai_static_params,
   $fai_loguser = $puppet::fai_loguser,
   $fai_root_password = $puppet::fai_root_password,
   $fai_debootstraps = $puppet::fai_debootstraps,
   $fai_locale = $puppet::fai_locale   
) inherits puppet {

   # common vars #
   $casrv_dns = $puppet::casrv_dns
   $puppetcarsync_password = $puppet::puppetcarsync_password
   $mastersrv_dns = $puppet::mastersrv_dns

   # ! used by dhcp ! #
   $fai_hosts = $puppet::fai_hosts

   ####################
   # puppet ca master #
   ####################
   anchor { 'puppet::camaster::begin': }->
   class { 'puppet::camaster::install': }->
   class { 'puppet::camaster::config': }~>
   class { 'puppet::camaster::service': }

   if $compiler_only == false and $enable_fai == true {
      class { 'puppet::camaster::fai':
         require => Class['puppet::camaster::service'],
         before => Anchor['puppet::camaster::end'],
      }
   }

   anchor { 'puppet::camaster::end': }

}
