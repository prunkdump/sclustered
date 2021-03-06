class apt::params {

   include network

   $port = 3142
   $http_proxy = $::network::http_proxy 
   $https_proxy = $::network::https_proxy
   $srv_dns = 'apt'
   $directs = []
   $remaps = {}
   $debian_reps = ['http://ftp.debian.org/debian']
   $distribution = 'stable'
   $sources = {
      base => ['http://debian','main contrib non-free'],
      security => ['http://security.debian.org/debian-security','main','stable/updates'],
   }
   $pinnings = {}
   $keys = []
   $autoupdates = []
   $autoupdate_blacklist = []
   $autoupdate_times = []
   $autoupdate_reboot = false
}
