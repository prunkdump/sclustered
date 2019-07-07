class pammount::config {

   concat { 'pam_mount.conf.xml':
      path => '/etc/security/pam_mount.conf.xml',
      ensure => present,
      mode => '0644',
   }

   concat::fragment{ 'pam_mount_header':
      target => 'pam_mount.conf.xml',
      source => 'puppet:///modules/pammount/pam_mount.conf.xml.header',
      order   => '01'
   }

   concat::fragment{ 'pam_mount_footer':
      target => 'pam_mount.conf.xml',
      source => 'puppet:///modules/pammount/pam_mount.conf.xml.footer',
      order   => '20'
   }

}
