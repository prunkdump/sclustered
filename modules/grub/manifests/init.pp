class grub {

   file_option { 'grub_timeout':
      path => '/etc/default/grub',
      option => 'GRUB_TIMEOUT',
      value => '0',
      separator => '=',
      multiple => false,
      ensure => present,
   }

   file_option { 'grub_timeout_style':
      path => '/etc/default/grub',
      option => 'GRUB_TIMEOUT_STYLE',
      value => '"hidden"',
      separator => '=',
      multiple => false,
      ensure => present,
   }

   exec { 'grub_config':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'update-grub',
      subscribe => File_option['grub_timeout', 'grub_timeout_style'],
      refreshonly => true,
   }

}
