class puppet::camaster::config {

   $casrv_dns = $puppet::camaster::casrv_dns
   $puppetcarsync_password = $puppet::camaster::puppetcarsync_password
   $mastersrv_dns = $puppet::camaster::mastersrv_dns

   ####################
   # configure puppet #
   ####################

   # dns_alt_names option #
   file_option { 'camaster_dns_alt_names':
      path => '/etc/puppet/puppet.conf',
      option => 'dns_alt_names',
      value => "${casrv_dns},${mastersrv_dns},${casrv_dns}.${::domain},${mastersrv_dns}.${::domain}",
      after => '\[main\]',
      multiple => false,
      ensure => present,
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
