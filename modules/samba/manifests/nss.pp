class samba::nss (
   $bind_module = 'winbind'
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

   package { 'libnss-winbind':
      ensure => $winbind_status,
   }


   # check sssd #
   if $bind_module == 'sssd' {
      $sssd_status = present
      include samba::sssd
   } else {
      $sssd_status = absent
   }

   package { 'libnss-sss':
      ensure => $sssd_status,
   }


   ##########
   # config #
   ##########

   # check winbind #
   if $bind_module == 'winbind' {

      file_option { 'add_winbind_nsswitch_passwd':
         path => '/etc/nsswitch.conf',
         option => 'passwd',
         value => "files systemd winbind",
         separator => ': ',
         ensure => present,
      }

      file_option { 'add_winbind_nsswitch_group':
         path => '/etc/nsswitch.conf',
         option => 'group',
         value => "files systemd winbind",
         separator => ': ',
         ensure => present,
      }

   }

    # check sssd #
    if $bind_module == 'sssd' {

      file_option { 'add_sssd_nsswitch_passwd':
         path => '/etc/nsswitch.conf',
         option => 'passwd',
         value => "files systemd sss",
         separator => ': ',
         ensure => present,
      }

      file_option { 'add_sssd_nsswitch_group':
         path => '/etc/nsswitch.conf',
         option => 'group',
         value => "files systemd sss",
         separator => ': ',
         ensure => present,
      }
   }
}
