class puppet::client::config {

   $fai_root_password = $puppet::client::fai_root_password
   $casrv_dns = $puppet::client::casrv_dns
   $mastersrv_dns = $puppet::client::mastersrv_dns

   ####################
   # configure puppet #
   ####################

   # set ca master #
   file_option { 'client_set_camaster':
      path => '/etc/puppet/puppet.conf',
      option => 'ca_server',
      value => $casrv_dns,
      after => '\[main\]',
      multiple => false,
      ensure => present,
   }

   # set master #
   file_option { 'client_set_master':
      path => '/etc/puppet/puppet.conf',
      option => 'server',
      value => $mastersrv_dns,
      after => '\[main\]',
      multiple => false,
      ensure => present,
   }

   ########################
   # ensure root password #
   ########################
   user { 'root':
      password => $fai_root_password,
      ensure => present,
   }

   #file {'/root/.ssh':
   #   ensure => directory,
   #   mode => '0700',
   #}

   # disabled because puppet:///modules/puppet/id_rsa.pub need to be manually copied # 
   #file {'/root/.ssh/authorized_keys':
   #   ensure => file,
   #   source => 'puppet:///modules/puppet/id_rsa.pub',
   #   mode => '0644',
   #   require => File['/root/.ssh'],
   #}
}
