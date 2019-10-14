class extrapkg (
   $apps = $extrapkg::params::apps,
) inherits extrapkg::params {

   ####################
   # example with deb #
   ####################
   #if 'mydebapp' in $apps {
   #
   #   file { '/opt/mydebapp.deb':
   #      ensure => present,
   #      source => 'puppet:///modules/extrapkg/pkg/mydebapp.deb',
   #      mode => '0644',
   #   }
   #
   #   exec { 'apt --yes --force-yes install /opt/mydebapp.deb':
   #      path => '/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/sbin',
   #      require => File['/opt/mydebapp.deb'],
   #      unless => "dpkg -s mydebapp",
   #   }
   #
   #}
   #else {
   #
   #   file { '/opt/mydebapp.deb':
   #      ensure => absent,
   #   }
   #
   #   package { 'mydebapp':
   #      ensure => absent,
   #   }
   #}


   ####################
   # example with tar #
   ####################
   #if 'mytarapp' in $apps {
   #
   #   file { '/opt/mytarapp.tar.xz':
   #      ensure => present,
   #      source => 'puppet:///modules/extrapkg/pkg/mytarapp.tar.xz',
   #      mode => '0644',
   #   }
   #
   #   exec { 'unpack_mytarapp':
   #      command => 'tar -C /opt/ -xf /opt/mytarapp.tar.xz && cp -r /opt/mytarapp/lib/icons/* /usr/share/icons/hicolor/',
   #      path => '/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/sbin',
   #      require => File['/opt/mytarapp.tar.xz'],
   #      creates => '/opt/mytarapp',
   #   }
   #
   #   file { '/usr/share/applications/mytarapp.desktop':
   #      ensure => present,
   #      source => 'puppet:///modules/extrapkg/pkg/mytarapp.desktop',
   #      mode => '0755',
   #   }
   #}
   #
   #else {
   #
   #
   #   file { ['/opt/mytarapp.tar.xz',
   #           '/opt/mytarapp',
   #           '/usr/share/applications/mytarapp.desktop',
   #           '/usr/share/icons/hicolor/16x16/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/96x96/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/64x64/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/48x48/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/72x72/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/128x128/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/32x32/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/24x24/apps/mytarapp.png',
   #           '/usr/share/icons/hicolor/256x256/apps/mytarapp.png']:
   #      ensure => absent,
   #   }
   #
   #}
   #
   #exec { 'mytarapp-update-mime':
   #   path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
   #   command => 'update-desktop-database && update-icon-caches /usr/share/icons/*',
   #   subscribe => File['/usr/share/applications/mytarapp.desktop'],
   #   refreshonly => true,
   #}


   ###############
   # flashplayer #
   ###############
   if 'flashplayer' in $apps {
      $flashplayer_status = 'present'
   }
   else {
      $flashplayer_status = 'absent'
   }
   
   file { '/usr/sbin/fireflashupdate':
      ensure => $flashplayer_status,
      source => 'puppet:///modules/extrapkg/fireflashupdate.sh',
      mode => '0744',
   }
   
   if $flashplayer_status == present  {
      exec { 'fireflashupdate':
         path => '/usr/bin:/usr/sbin:/bin',
         require => File['/usr/sbin/fireflashupdate'],
         subscribe => File['/usr/sbin/fireflashupdate'],
         refreshonly => true,
      }
   }
   
   # cron job to update  #
   file { 'update-flashplugin':
      path => '/etc/cron.daily/update-flashplugin',
      ensure => $flashplayer_status,
      source => 'puppet:///modules/extrapkg/update-flashplugin',
      mode => '0755',
      require => File['/usr/sbin/fireflashupdate'],
   }


   ##########
   # libdvd #
   ##########
   if 'libdvd' in $apps {
      $libdvd_status = 'present'
   }
   else {
      $libdvd_status = 'absent'
   }
   
   package { 'libdvd-pkg':
      ensure => $libdvd_status,
   }
   
   if $libdvd_status == 'present' {
   
      exec {'install_libdvd_pkg':
         path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
         #logoutput => true,
         command => '/usr/lib/libdvd-pkg/b-i_libdvdcss.sh',
         subscribe => Package['libdvd-pkg'],
         refreshonly => true,
      }
   
   }
   
}
