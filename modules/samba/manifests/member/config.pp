class samba::member::config {

   $realm = $samba::member::realm
   $short_domain = $samba::member::short_domain
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
}
