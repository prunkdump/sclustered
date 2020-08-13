class puppet::camaster::config {

   $compiler_only = $puppet::camaster::compiler_only
   $casrv_dns = $puppet::camaster::casrv_dns
   $puppetcarsync_password = $puppet::camaster::puppetcarsync_password
   $mastersrv_dns = $puppet::camaster::mastersrv_dns

   ####################
   # configure puppet #
   ####################

   # dns_alt_names option #
   if $compiler_only != true {
      $dns_alt_names_value = "${casrv_dns},${mastersrv_dns},${casrv_dns}.${::domain},${mastersrv_dns}.${::domain}"
   } else {
      $dns_alt_names_value = "${mastersrv_dns},${mastersrv_dns}.${::domain}"
   }

   file_option { 'camaster_dns_alt_names':
      path => '/etc/puppet/puppet.conf',
      option => 'dns_alt_names',
      value => "$dns_alt_names_value",
      after => '\[main\]',
      multiple => false,
      ensure => present,
   }

   # ca option #
   if $compiler_only == true {

      # disable ca #
      file_option { 'master_disable_ca':
         path => '/etc/puppet/puppet.conf',
         option => 'ca',
         value => 'false',
         after => '\[main\]',
         multiple => false,
         ensure => present,
      }

      # specify ca server #
      file_option { 'master_set_camaster':
         path => '/etc/puppet/puppet.conf',
         option => 'ca_server',
         value => $casrv_dns,
         after => '\[main\]',
         multiple => false,
         ensure => present,
      }
   }


   # base module path #
   file_option { 'camaster_basemodulepath':
      path => '/etc/puppet/puppet.conf',
      option => 'basemodulepath',
      value => '$confdir/modules',
      after => '\[main\]',
      multiple => false,
      ensure => present,
   }

   # environment path #
   file_option { 'camaster_environmentpath':
      path => '/etc/puppet/puppet.conf',
      option => 'environmentpath',
      value => '$confdir/environments',
      after => '\[main\]',
      multiple => false,
      ensure => present,
   }

   # change client server to localhost #
   #file_option { 'camaster_server':
   #   path => '/etc/puppet/puppet.conf',
   #   option => 'server',
   #   value => 'localhost',
   #   after => '\[main\]',
   #   multiple => false,
   #   ensure => present,
   #}

   # the agent need to use the localhost server #
   file_line { 'add_puppet_host_entry':
      path => '/etc/hosts',
      line => "${::ipaddress}     puppet.${::domain}      puppet",
      match => 'puppet',
      ensure => present,
      multiple => false,
   }

   ############################
   # rsync export the modules #
   ############################

   rsync::server::export { 'puppetca':
      path => '/etc/puppet',
      password => $puppetcarsync_password,
   }
}
