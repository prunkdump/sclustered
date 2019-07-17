class puppet (
   $casrv_dns = $puppet::params::casrv_dns,
   $puppetcarsync_password = $puppet::params::puppetcarsync_password, 
   $mastersrv_dns = $puppet::params::mastersrv_dns,
   $enable_fai = $puppet::params::enable_fai,
   $fai_pxe_finename = $puppet::params::fai_pxe_finename,
   $fai_loguser = $puppet::params::fai_loguser,
   $fai_root_password = $puppet::params::fai_root_password,
   $fai_debootstraps = $puppet::params::fai_debootstraps,
   $fai_hosts = $puppet::params::fai_hosts,
   $fai_locale = $puppet::params::fai_locale
) inherits puppet::params {



}
