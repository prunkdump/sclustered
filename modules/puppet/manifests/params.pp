class puppet::params {

   $casrv_dns = 'puppetca'
   $puppetcarsync_password = 'oi-wm)tr!yu' 
   $mastersrv_dns = 'puppet'
   $enable_fai = true 
   $fai_pxe_finename = 'fai/pxelinux.0'
   $fai_loguser = 'fai'
   $fai_root_password = '$1$kBnWcO.E$djxB128U7dMkrltJHPf6d1' 
   $fai_debootstraps = {}
   $fai_hosts = {}
   $fai_locale = {
      'main' => 'en_US.UTF8',
      'task' => 'english',
      'keymap' => 'us',
      'xkbmodel' => 'pc105',
      'xkbmodelname' => 'Generic 105-key PC (intl.)',
      'xkblayout' => 'en',
      'xkbvariant' => 'US',
      'xkboptions' => 'ctrl:nocaps,terminate:ctrl_alt_bksp'
   }
}
