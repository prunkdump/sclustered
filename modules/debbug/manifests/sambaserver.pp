class debbug::sambaserver {

   ####################################
   # rndc reload crash bind samba dlz #
   ####################################
   file { '/usr/sbin/rndc':
      ensure => present,
      source => 'puppet:///modules/debbug/rndc',
      backup => '.ORIG'
      mode => '0755',
   }

   ######################################
   # gssproxy make looping dependencies #
   ######################################
   #exec {'remove_gssproxy_remote_fs_dependency':
   #   path => '/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
   #   command => 'sed -i "s/\$remote_fs//g" /etc/init.d/gssproxy',
   #   onlyif => 'grep -q "\$remote_fs" /etc/init.d/gssproxy',
   #}

}
