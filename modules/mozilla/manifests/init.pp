class mozilla (
   $start_page = $mozilla::params::start_page,
   $paper_size = $mozilla::params::paper_size, 
   $cache_size = $mozilla::params::cache_size,
   $http_proxy = $mozilla::params::http_proxy,
   $https_proxy = $mozilla::params::https_proxy,
   $no_proxy_list = $mozilla::params::no_proxy_list,
   $firefox_prefs = $mozilla::params::firefox_prefs,
   $thunderbird_prefs = $mozilla::params::thunderbird_prefs,
) inherits mozilla::params { 


   anchor { 'mozilla::begin': }->
   class { 'mozilla::install': }->
   class { 'mozilla::config': }->
   anchor { 'mozilla::end': }


}
