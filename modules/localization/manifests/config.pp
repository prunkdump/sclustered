class localization::config {

   $generated_locales = $localization::generated_locales

   file { '/etc/locale.gen':
      ensure => file,
      content => template('localization/locale.gen.erb'),
      mode => '0644',
   }
   
   exec { 'locale-gen':
      path => '/usr/bin:/usr/sbin:/bin',
      refreshonly => true,
      subscribe => File['/etc/locale.gen'],
   }
}



   
