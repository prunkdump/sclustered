class samba::pdc::install {

   $interfaces = $samba::pdc::interfaces
   $realm = $samba::pdc::realm
   $short_domain = $samba::pdc::short_domain
   $default_admin_pass = $samba::pdc::default_admin_pass
   $etc_path = $samba::pdc::etc_path
   $private_path = $samba::pdc::private_path

   #################
   # main packages #
   #################

   # samba packages #
   package { ['samba','winbind','dnsutils','acl','ntp','dos2unix']:
      ensure => installed,
   }

   # kerberos packages #
   package { krb5-user:
      ensure => installed,
   }

   # quota tools #
   package { ['quota','quotatool']:
      ensure => installed,
   }

   ###################
   # samba provision #
   ###################

   # provision samba #
   $interfaces_flat = join($interfaces, ' ')
   exec { 'samba4_provision':
      path => '/usr/bin:/usr/sbin:/bin',
      command => "rm -f $etc_path/smb.conf && \
                  samba-tool domain provision --option=\"interfaces = $interfaces_flat\" \
                  --option=\"bind interfaces only = yes\" --use-rfc2307 \
                  --realm=$realm --domain=$short_domain \
                  --adminpass=$default_admin_pass --server-role=dc --dns-backend=BIND9_DLZ",
      creates => "$private_path/sam.ldb",
      require => Package['samba'],
   }

   # set krb5 #
   file { '/etc/krb5.conf':
      ensure => present,
      source => "file:$private_path/krb5.conf",
      require => Exec['samba4_provision'],
      mode => '0644',
   }
}
