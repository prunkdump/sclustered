class samba::member::config {

   $samba_realm = $samba::member::realm
   $samba_short_domain = $samba::member::short_domain
   $etc_path = $samba::member::etc_path   

   #######################
   # samba member config #
   #######################
   file { 'smb.conf':
      path => "$etc_path/smb.conf",
      ensure => file,
      content => template('samba/member_smb.conf.erb'),
      mode => '0644',
   }

   file {'/etc/krb5.conf':
      ensure => file,
      content => template('samba/member_krb5.conf.erb'),
      mode => '0644',
   }
}
