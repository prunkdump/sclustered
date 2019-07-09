define apt::server::remap ( $map_name = $title, $targets ) {

   $target = $targets[$map_name]

   file_option { "acng_remap_$map_name":
      path => '/etc/apt-cacher-ng/acng.conf',
      option => "Remap-$map_name",
      value => "/$map_name ; $target",
      after => '# Repository remapping',
      separator => ': ',
      multiple => false,
      ensure => present,
   }
}

