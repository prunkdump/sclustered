class puppet::camaster::config {

   $compiler_only = $puppet::camaster::compiler_only
   $casrv_dns = $puppet::camaster::casrv_dns
   $puppetcarsync_password = $puppet::camaster::puppetcarsync_password
   $mastersrv_dns = $puppet::camaster::mastersrv_dns

   ####################
   # configure puppet #
   ####################

   # dns_alt_names option #
   $dns_alt_names_value = "${casrv_dns},${mastersrv_dns},${casrv_dns}.${::domain},${mastersrv_dns}.${::domain}"

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

      file_line { 'passenger_set_ca_certificate' :
         path => '/etc/apache2/sites-available/puppet-master.conf',
         line => '        SSLCARevocationFile     /var/lib/puppet/ssl/crl.pem',
         match => 'SSLCARevocationFile',
         ensure => present,
         multiple => false,
      }

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

   else {

      file_line { 'passenger_set_ca_certificate' :
         path => '/etc/apache2/sites-available/puppet-master.conf',
         line => '        SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem',
         match => 'SSLCARevocationFile',
         ensure => present,
         multiple => false,
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

   # ensure passenger enabled #
   exec { 'enable_puppet_master_passenger':
      command => 'a2ensite puppet-master',
      path => '/usr/bin:/usr/sbin:/bin',
      creates => '/etc/apache2/sites-enabled/puppet-master.conf',
   }

   # change client server to localhost #
   # OLD VERSION
   #file_option { 'camaster_server':
   #   path => '/etc/puppet/puppet.conf',
   #   option => 'server',
   #   value => 'localhost',
   #   after => '\[main\]',
   #   multiple => false,
   #   ensure => present,
   #}

   # the agent need to use the localhost server #
   # DISABLED, this change the server during catalog apply #
   #file_line { 'add_puppet_host_entry':
   #   path => '/etc/hosts',
   #   line => "${::ipaddress}     puppet.${::domain}      puppet",
   #   match => 'puppet',
   #   ensure => present,
   #   multiple => false,
   #}

   ############################
   # rsync export the modules #
   ############################

   rsync::server::export { 'puppetca':
      path => '/etc/puppet',
      password => $puppetcarsync_password,
   }
}
