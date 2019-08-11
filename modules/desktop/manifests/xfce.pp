class desktop::xfce {

   anchor { 'desktop::xfce::begin': } ->
   class { 'desktop::xfce::install': } ->
   class { 'desktop::xfce::config': } ~>
   class { 'desktop::xfce::service': } ->
   anchor { 'desktop::xfce::end': }

}

