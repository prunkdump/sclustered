class nfs::service {

   # services not needed on server since stretch #
   #if ! defined( Class['nfs::server'] ) {
   #
   #   # common nfs service #
   #   service { 'nfs-common':
   #     ensure    => running,
   #     enable    => true,
   #  }
   #}
}
