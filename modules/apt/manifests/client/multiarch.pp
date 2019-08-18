class apt::client::multiarch {

   exec {"add_arch_i386":
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => "dpkg --add-architecture i386",
      unless  => "dpkg --print-foreign-architectures | grep i386",
      require => Class['apt::client::config'],
      notify => Class['apt::client::update'],
   }
}

