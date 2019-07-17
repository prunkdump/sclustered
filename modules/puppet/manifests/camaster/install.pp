class puppet::camaster::install {

   $casrv_dns = $puppet::camaster::casrv_dns
   $mastersrv_dns = $puppet::camaster::mastersrv_dns
 
   include network
   include samba

   $reverse_zone = $::network::reverse_zone
   $samba_realm = $::samba::realm
   $samba_domain = $::samba::domain

   package { 'puppetmaster-passenger':
      ensure => installed,
   }


   # script to promote new dc #
   file { '/usr/sbin/dc-join':
      ensure => file,
      content => template('puppet/dc-join.erb'),
      mode => '0744',
   }

 
}
