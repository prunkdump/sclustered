class apt::params {

   include network

   $port = 3142
   $http_proxy = $::network::http_proxy 
   $https_proxy = $::network::https_proxy
   $srv_dns = 'apt'
   $directs = []
   $remaps = {}
   $debian_reps = ['http://deb.debian.org/debian']
   $distribution = 'stable'
   $sources = {
      base => ['http://debian','main contrib non-free non-free-firmware'],
      security => ['http://debian-security','main','bookworm-security'],
   }
   $pinnings = {}
   $keys = []
   $autoupdates = []
   $autoupdate_blacklist = []
   $autoupdate_times = []
   $autoupdate_reboot = false
}
