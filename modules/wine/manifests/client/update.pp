class wine::client::update {

   exec { 'wine-update-mime':
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'update-desktop-database',
      refreshonly => true,
   }

}
