class localization (
   $generated_locales = $localization::params::generated_locales
) inherits localization::params {
 
  
   anchor { 'localization::begin': } ->
   class { 'localization::config': } ->
   anchor { 'localization::end': }
}

