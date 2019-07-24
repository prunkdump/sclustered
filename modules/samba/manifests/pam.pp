class samba::pam (
   $bind_module = 'winbind',
   #$umask = '022'
) {

   ############
   # packages #
   ############

   # check winbind #
   if $bind_module == 'winbind' {
      $winbind_status = present
   } else {
      $winbind_status = absent
   }

   package { 'libpam-winbind':
      ensure => $winbind_status,
   }


   # check sssd #
   if $bind_module == 'sssd' {
      $sssd_status = present
      include samba::sssd
   } else {
      $sssd_status = absent
   }

   package { 'libpam-sss':
      ensure => $sssd_status,
   }

   ##########
   # config #
   ##########

   # umask #
   #file { '/usr/share/pam-configs/umask':
   #   ensure => present,
   #   source => 'puppet:///modules/samba/umask',
   #   mode => '0644',
   #}

   #file_option { 'logindef_umask':
   #   path => '/etc/login.defs',
   #   option => 'UMASK',
   #   value => $umask,
   #   separator => ' ',
   #   multiple => false,
   #   ensure => present,
   #}

   #exec { 'pam_umask_auth_update' :
   #   command => 'pam-auth-update --force',
   #   path => '/usr/bin:/usr/sbin:/bin',
   #   subscribe => File['/usr/share/pam-configs/umask'],
   #   refreshonly => true,
   #}

   # check winbind #
   if $bind_module == 'winbind' {

      # fix bug for pam_winbind passwd #
      #file { '/usr/share/pam-configs/winbind':
      #   ensure => present,
      #   source => 'puppet:///modules/samba/winbind',
      #   mode => '0644',
      #   require => Package['libpam-winbind'],
      #}

      #exec { 'pam_winbind_auth_update' :
      #   command => 'pam-auth-update --force',
      #   path => '/usr/bin:/usr/sbin:/bin',
      #   subscribe => File['/usr/share/pam-configs/winbind'],
      #   refreshonly => true,
      #}

      # ! managed by the samba daemon !
      #exec { 'samba_create_keytab':
      #   path => '/usr/bin:/usr/sbin:/bin',
      #   command => 'net ads keytab create -P',
      #   creates => '/etc/krb5.keytab',
      #}

      # fix bug for pam_winbind auth #
      #file { '/etc/krb5.keytab':
      #   ensure => file,
      #   owner => root,
      #   group => root,
      #   mode => '0660',
      #   #require => Exec['samba_create_keytab'],
      #}
   }

}
