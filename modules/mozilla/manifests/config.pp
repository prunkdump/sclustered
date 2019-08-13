class mozilla::config {

   $start_page = $mozilla::start_page
   $paper_size = $mozilla::paper_size 
   $cache_size = $mozilla::cache_size
   $http_proxy = $mozilla::http_proxy
   $https_proxy = $mozilla::https_proxy
   $no_proxy_list = $mozilla::no_proxy_list
   $firefox_prefs = $mozilla::firefox_prefs
   $thunderbird_prefs = $mozilla::thunderbird_prefs

   ##########
   # config #
   ##########
   if( $http_proxy ){
      $http_proxy_params = split($http_proxy,':')
      $http_proxy_host = $http_proxy_params[0]
      $http_proxy_port = $http_proxy_params[1]
   }
   if( $https_proxy ){ 
      $https_proxy_params = split($https_proxy,':') 
      $https_proxy_host = $https_proxy_params[0]
      $https_proxy_port = $https_proxy_params[1]
   }

   ####################
   #  firefox config  #
   ####################

   file { ['/usr/lib/firefox-esr',
           '/usr/lib/firefox-esr/defaults',
           '/usr/lib/firefox-esr/defaults/pref']:
      ensure => directory,
   } 
  
   file { 'firefox_mozilla_cfg':
      path    => '/usr/lib/firefox-esr/mozilla.cfg',
      ensure  => file,
      content => template("mozilla/firefox-mozilla.cfg.erb"),
      mode => '0644',
      require => File['/usr/lib/firefox-esr'],
   }

   file { 'firefox_local_settings':
      path    => '/usr/lib/firefox-esr/defaults/pref/local-settings.js',
      ensure  => file,
      source => "puppet:///modules/mozilla/local-settings.js",
      mode => '0644',
      require => File['/usr/lib/firefox-esr/defaults/pref'],
   }

   ##########################
   #  thunderbird settings  #
   ##########################

   file { ['/usr/lib/thunderbird',
           '/usr/lib/thunderbird/defaults',
           '/usr/lib/thunderbird/defaults/pref']:
      ensure => directory,
   }

   file { 'thunderbird_mozilla_cfg':
      path    => '/usr/lib/thunderbird/mozilla.cfg',
      ensure  => file,
      content => template("mozilla/thunderbird-mozilla.cfg.erb"),
      mode => '0644',
      require => File['/usr/lib/thunderbird'],
   }

   file { 'thunderbird_local_settings':
      path    => '/usr/lib/thunderbird/defaults/pref/local-settings.js',
      ensure  => file,
      source => "puppet:///modules/mozilla/local-settings.js",
      mode => '0644',
      require => File['/usr/lib/thunderbird/defaults/pref'],
   }

   ###################
   #  javaws config  #
   ###################

   file { ['/etc/.java',
           '/etc/.java/deployment']:
      ensure => directory,
   }

   file { 'javaws_deployment_config':
      path    => '/etc/.java/deployment/deployment.config',
      ensure  => file,
      source => "puppet:///modules/mozilla/deployment.config",
      mode => '0644',
      require => File['/etc/.java/deployment'],
   }

   file { 'javaws_deployment_settings':
      path    => '/etc/.java/deployment/deployment.settings',
      ensure  => file,
      content => template("mozilla/deployment.settings.erb"),
      mode => '0644',
      require => File['/etc/.java/deployment'],
   }

   # ???
   # configure /etc/java-*-openjdk/net.properties 

}
