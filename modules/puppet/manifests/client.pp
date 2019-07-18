class puppet::client(
   $fai_root_password = $puppet::fai_root_password
) inherits puppet {

   # common vars #
   $casrv_dns = $puppet::casrv_dns
   $mastersrv_dns = $puppet::mastersrv_dns
   
   #################
   # puppet client #
   #################
   anchor { 'puppet::client::begin': }->
   class { 'puppet::client::install': }->
   class { 'puppet::client::config': }~>
   class { 'puppet::client::service': }->
   anchor { 'puppet::client::end': }

}
