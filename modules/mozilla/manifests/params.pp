class mozilla::params {

   include network

   $start_page = undef
   $paper_size = undef
   $cache_size = undef
   $http_proxy = $::network::http_proxy
   $https_proxy = $::network::https_proxy
   $no_proxy_list = [$::network::slashform]
   $firefox_prefs = []
   $thunderbird_prefs = []
}
