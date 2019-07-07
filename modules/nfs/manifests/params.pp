class nfs::params {

   include samba

   # no translations #
   $translations = {}

   # use cachefile daemon #
   $enable_cachefilesd = false

   # standard nfs4 root file system #
   $root_path = '/srv/nfs4'

   # get network #
   include network
   $network = $::network::slashform

   # nfs home share #
   $home_share = '/home'

   # for the client home #
   $home_server = $samba::accountsrv_dns

   # number of nfsd #
   $daemon_count = 8

   # default options #
   $export_options = ['rw','async','no_subtree_check']
   $nfs4_export_options = ['sec=krb5']
   $mount_options = [ ]
   $nfs4_mount_options = ['sec=krb5']

}
