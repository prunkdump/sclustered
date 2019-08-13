class keyboard (
   $model = $keyboard::params::model,
   $layout = $keyboard::params::layout,
   $variant = $keyboard::params::variant,
   $options = $keyboard::params::options,
   $disable_numlock = $keyboard::params::disable_numlock
) inherits keyboard::params {

   anchor { 'keyboard::begin': } ->
   class { 'keyboard::install': } ->
   class { 'keyboard::config': } ~>
   class { 'keyboard::service': } ->
   anchor { 'keyboard::end': }

}
