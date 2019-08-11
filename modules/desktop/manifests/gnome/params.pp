class desktop::gnome::params {

   include network

   $dash_apps = []
   $extensions = []
   $idle_time = 300
   $autologout_time = undef
   $http_proxy = $::network::http_proxy
   $https_proxy = $::network::https_proxy

}
