class apt::client::audit {

   # conf file configuration #
   file { '01conffiles':
      path => '/etc/apt/apt.conf.d/01conffiles',
      ensure => present,
      source => "puppet:///modules/apt/01conffiles",
      mode => '0644',
   }


   # audit apt status #
   exec { 'apt_configure_partially':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'apt-get update && apt-get clean && ( dpkg --configure -a || apt-get -f -y install || apt --fix-broken install )',
      onlyif => 'dpkg --audit | grep -q .',
      require => File['01conffiles'],
   }

}
