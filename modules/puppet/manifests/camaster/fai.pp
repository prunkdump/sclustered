##########################
# create fai config tree #
##########################
define puppet::camaster::fai::debootstrap::conf ($base_fai_conf, $fai_distribution, $fai_arch) {

   # class variables #   
   $apt_debian_reps = $puppet::camaster::fai::apt_debian_reps 
   $fai_root_password = $puppet::camaster::fai::fai_root_password

   # base directories #
   file { ["$base_fai_conf","${base_fai_conf}/apt"]:
      ensure => directory,
      mode => '0755',
   }

   # file linked #
   # same for all bootstrap #
   file { "${base_fai_conf}/fai.conf":
      ensure => link,
      target => '/etc/fai/fai.conf',
   }

   file { "${base_fai_conf}/NFSROOT":
      ensure => link,
      target => '/etc/fai/NFSROOT',
   }

   file { "${base_fai_conf}/grub.cfg":
      ensure => link,
      target => '/etc/fai/grub.cfg',
   }

   # specific conf #
   file { "${base_fai_conf}/apt/sources.list":
      ensure => file,
      content => template('puppet/fai_sources.list.erb'),
      mode => '0644',
   }

   file { "${base_fai_conf}/nfsroot.conf":
      ensure => file,
      content => template('puppet/nfsroot.conf.erb'),
      mode => '0644',
   }
}


########################
# build fai deboostrap #
########################
define puppet::camaster::fai::debootstrap ( $debootname = $title, $params ) {

   # static conf ? # 
   $fai_static_params = $puppet::camaster::fai::fai_static_params
   if( $fai_static_params ) {
      $fai_static_params_files_status = file
   } else {
      $fai_static_params_files_status = absent
   }
   $samba_domain = $puppet::camaster::fai::samba_domain
   $casrv_dns = $puppet::camaster::fai::casrv_dns
  
   # class variables #
   $apt_proxy_host = $puppet::camaster::fai::apt_proxy_host
   $apt_proxy_port = $puppet::camaster::fai::apt_proxy_port

   #  base conf path #
   $fai_distribution = $params[$debootname][0]
   $fai_arch = $params[$debootname][1]
   $base_conf_path = "/etc/fai-debootstraps/fai-${fai_distribution}-${fai_arch}"

   # create conf #
   puppet::camaster::fai::debootstrap::conf { "$debootname":
      base_fai_conf => $base_conf_path,
      fai_distribution => $fai_distribution,
      fai_arch => $fai_arch,
   }

   # build debootstrap #
   exec { "fai-setup -e -C $base_conf_path":
      path => '/usr/bin:/usr/sbin:/bin',
      creates => "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}",
      timeout => 0,
      require => Puppet::Camaster::Fai::Debootstrap::Conf["$debootname"],
   }

   file { "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}":
      ensure => directory,
      require => Exec["fai-setup -e -C $base_conf_path"],
   }

   file { "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/etc/apt/sources.list":
      ensure => file,
      content => template('puppet/fai_nfsroot_sources.list.erb'),
      mode => '0644',
      require => [Exec["fai-setup -e -C $base_conf_path"],File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}"]],
   }

   # if static parameters, force DHCP parameters during FAI intallation #
   # TFTP will be acceded by NFS to get host info #
   file { "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/var/lib/fai/config/hooks/confdir.DEFAULT":
      ensure => $fai_static_params_files_status,
      content => template('puppet/fai_static_dhcp_confdir.DEFAULT.erb'),
      mode => '0755',
      require => [Exec["fai-setup -e -C $base_conf_path"],File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}"]],
   }

   # create boot cd #
   file { "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd":
      ensure => directory,
      mode => '0755',
      require => [Exec["fai-setup -e -C $base_conf_path"],File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}"]],
   }

   file { "/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd/grub.cfg":
      ensure => file,
      content => template('puppet/fai-iso-grub.cfg.erb'),
      mode => '0644',
      require => [Exec["fai-setup -e -C $base_conf_path"],
                  File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}","/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd"]],
   }
   
   exec { "fai-cd -f -C $base_conf_path -B -g /srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd/grub.cfg /srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd/fai-boot.iso":
      path => '/usr/bin:/usr/sbin:/bin',
      require => [Exec["fai-setup -e -C $base_conf_path"],
                  File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}","/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd"]],
      subscribe => File["/srv/fai/nfsroot-${fai_distribution}-${fai_arch}/boot-cd/grub.cfg"],
      refreshonly => true,
   }

}

##########################
# create fai host config #
##########################
define puppet::camaster::fai::faihost (
   $host_name = $title,
   $fai_hosts_hash,
   $fai_debootstraps_hash,
   $fai_host_file,
   $server,
) {

   # static conf ? # 
   $fai_static_params = $puppet::camaster::fai::fai_static_params

   # get host param #
   $host_mac = $fai_hosts_hash[$host_name][0]
   $host_dmac = downcase($host_mac)
   $host_mac_split = split($host_dmac, ':')
   $host_mac_join = join($host_mac_split, '-')
   $host_mac_filename = "01-$host_mac_join"
   $host_debootstrap = $fai_hosts_hash[$host_name][1]
   $host_class = $fai_hosts_hash[$host_name][2]

   # get debootstrap params #
   $host_deb_distribution = $fai_debootstraps_hash[$host_debootstrap][0]
   $host_deb_arch = $fai_debootstraps_hash[$host_debootstrap][1]

   # if static parameters, add hostname to kernel cmdline #
   if( $fai_static_params ) {

      exec { "add_fai_conf_${host_name}":
         command => "fai-chboot -C /etc/fai-debootstraps/fai-${host_deb_distribution}-${host_deb_arch} \
                    -IFv -u nfs://${server}/srv/fai/config -k hostname=$host_name $host_mac",
         path => '/usr/bin:/usr/sbin:/bin',
         creates => "/srv/tftp/fai/pxelinux.cfg/$host_mac_filename",
      }

   } else {

      exec { "add_fai_conf_${host_name}":
         command => "fai-chboot -C /etc/fai-debootstraps/fai-${host_deb_distribution}-${host_deb_arch} \
                    -IFv -u nfs://${server}/srv/fai/config -k $host_mac",
         path => '/usr/bin:/usr/sbin:/bin',
         creates => "/srv/tftp/fai/pxelinux.cfg/$host_mac_filename",
      }
   }

   file { "/srv/tftp/fai/pxelinux.cfg/$host_mac_filename":
      ensure => present,
      require => Exec["add_fai_conf_${host_name}"],
   }
}

##################################################################################


##############
# intall FAI #
##############
class puppet::camaster::fai {

   $casrv_dns = $puppet::camaster::casrv_dns
   $mastersrv_dns = $puppet::camaster::mastersrv_dns   

   include network
   include samba
   include apt

   $fai_static_params = $puppet::camaster::fai_static_params
   if( $fai_static_params ) {
      $fai_static_params_files_status = file
   } else {
      $fai_static_params_files_status = absent
   }

   $fai_loguser = $puppet::camaster::fai_loguser
   $fai_root_password = $puppet::camaster::fai_root_password
   $fai_debootstraps = $puppet::camaster::fai_debootstraps
   $fai_hosts = $puppet::camaster::fai_hosts
   $fai_locale = $puppet::camaster::fai_locale

   $apt_debian_reps = $::apt::debian_reps
   $apt_proxy_host = $::apt::srv_dns
   $apt_proxy_port = $::apt::port

   $http_proxy = $::network::http_proxy
   $https_proxy = $::network::https_proxy
   $reverse_zone = $::network::reverse_zone

   $samba_realm = $::samba::realm
   $samba_domain = $::samba::domain
   $samba_short_domain = $::samba::short_domain
   $samba_idmap_range = $::samba::idmap_range
   
   ###########
   # package #
   ###########

   package { 'fai-quickstart':
      ensure => installed,
   }

   ###############
   # main config #
   ###############
   
   # main configuration file #
   file { '/etc/fai/fai.conf':
      ensure => file,
      content => template('puppet/fai.conf.erb'),
      mode => '0644',
      require => Package['fai-quickstart'],
   }

   # nfsroot config #
   # !! directories fully managged !! #
   file { '/etc/fai-debootstraps':
      ensure => directory,
      recurse => true,
      purge => true,
      force => true,
   }

   file { '/srv/fai':
      ensure => directory,
      recurse => true,
      purge => true,
      force => true,
      recurselimit => 1,
      require => Package['fai-quickstart'],
   }

   $debootstrap_list = keys($fai_debootstraps)
   puppet::camaster::fai::debootstrap { $debootstrap_list:
      params => $fai_debootstraps,
      require => Package['fai-quickstart'],
   }

   # fai base config #
   # exec permission is needed so apply to all files #
   file { '/srv/fai/config':
      ensure => directory,
      source => 'file:/usr/share/doc/fai-doc/examples/simple',
      recurse => true,
      purge => true,
      force => true,
      mode => '0755',
      require => [Package['fai-quickstart'],File['/srv/fai']],
   }

   ##############
   # fai config #
   ##############

   # disk_config #
   file {'/srv/fai/config/disk_config/FAIBASE':
      ensure => file,
      source => 'puppet:///modules/puppet/disk_config_FAIBASE',
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file {'/srv/fai/config/disk_config/FAIBASE_EFI':
      ensure => file,
      source => 'puppet:///modules/puppet/disk_config_FAIBASE_EFI',
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

  
   # locale #
   file { '/srv/fai/config/debconf/LOCALE':
      ensure => file,
      content => template('puppet/debconf_LOCALE.erb'),
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file { '/srv/fai/config/package_config/LOCALE':
      ensure => file,
      content => template('puppet/package_LOCALE.erb'),
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file { '/srv/fai/config/class/LOCALE.var':
      ensure => file,
      content => template('puppet/class_LOCALE.var.erb'),
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   # proxy #
   if $http_proxy or $https_proxy {
      $fai_proxy_file_status = present
   } else {
      $fai_proxy_file_status = absent
   }

   file { '/srv/fai/config/hooks/instsoft.PROXY':
      ensure => $fai_proxy_file_status,
      content => template('puppet/instsoft.PROXY.erb'),
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   # samba #
   file { ['/srv/fai/config/files/etc',
           '/srv/fai/config/files/etc/samba',
           '/srv/fai/config/files/etc/samba/smb.conf',
           '/srv/fai/config/files/etc/krb5.conf']:
      ensure => directory,
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file { '/srv/fai/config/files/etc/krb5.conf/S4CLIENT':
      ensure => file,
      content => template('puppet/file_krb5.conf.erb'),
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc/krb5.conf']],
   }

   file { '/srv/fai/config/files/etc/samba/smb.conf/S4CLIENT':
      ensure => file,
      content => template('puppet/client_smb.conf.erb'),
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc/samba/smb.conf']],
   }

   file { '/srv/fai/config/package_config/S4CLIENT':
      ensure => file,
      source => 'puppet:///modules/puppet/package_S4CLIENT',
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   # hosts file #
   file { '/srv/fai/config/files/etc/hosts':
      ensure => directory,
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc']],
   }

   file { '/srv/fai/config/files/etc/hosts/FAIBASE':
      ensure => file,
      source => 'puppet:///modules/puppet/file_hosts',
      mode => '0644',
      require => [Package['fai-quickstart'], File['/srv/fai/config'],File['/srv/fai/config/files/etc/hosts']],
   }

   # nsupdate #
   file { ['/srv/fai/config/files/etc/dhcp',
           '/srv/fai/config/files/etc/dhcp/dhclient-enter-hooks.d','/srv/fai/config/files/etc/dhcp/dhclient-enter-hooks.d/nsupdate',
           '/srv/fai/config/files/etc/dhcp/dhclient-exit-hooks.d','/srv/fai/config/files/etc/dhcp/dhclient-exit-hooks.d/nsupdate']:
      ensure => directory,
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc']],
   }

   file { '/srv/fai/config/files/etc/dhcp/dhclient-enter-hooks.d/nsupdate/S4CLIENT':
      ensure => file,
      content => template('puppet/nsupdate_enter.erb'),
      mode => '0744',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc/dhcp/dhclient-enter-hooks.d/nsupdate']],
   }

   file { '/srv/fai/config/files/etc/dhcp/dhclient-exit-hooks.d/nsupdate/S4CLIENT':
      ensure => file,
      content => template('puppet/nsupdate_exit.erb'),
      mode => '0744',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/files/etc/dhcp/dhclient-exit-hooks.d/nsupdate']],
   }


   # ssh #
   file { '/srv/fai/config/hooks/setup.DEFAULT':
      ensure => file,
      source => 'puppet:///modules/puppet/script_setup.DEFAULT',
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   exec { 'ensure_root_ssh_key':
      command => "ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa",
      path => '/usr/bin:/usr/sbin:/bin',
      creates => '/root/.ssh/id_rsa.pub',
      require => [Package['fai-quickstart'],File['/srv/fai','/srv/fai/config']],
   }

   file { ['/srv/fai/config/files/root','/srv/fai/config/files/root/.ssh','/srv/fai/config/files/root/.ssh/authorized_keys']:
      ensure => directory,
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file { '/srv/fai/config/files/root/.ssh/authorized_keys/S4CLIENT':
      ensure => file,
      source => 'file:///root/.ssh/id_rsa.pub',
      mode => '0600',
      require => [Package['fai-quickstart'], Exec['ensure_root_ssh_key'],File['/srv/fai/config','/srv/fai/config/files/root/.ssh/authorized_keys']],
   }

   # main script #
   file { '/srv/fai/config/scripts/S4CLIENT':
      ensure => directory,
      mode => '0755',  
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   file { '/srv/fai/config/scripts/S4CLIENT/10-main':
      ensure => file,
      content => template('puppet/script_10-main.erb'),
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/scripts/S4CLIENT']],
   }

   # if static parameters, ignore DHCP parameters #
   file { '/srv/fai/config/scripts/S4CLIENT/20-static-dhcp.erb':
      ensure => $fai_static_params_files_status,
      content => template('puppet/fai_static_dhcp_script_20-static-dhcp.erb'),
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config'], File['/srv/fai/config/scripts/S4CLIENT']],
   }

   # host base class #
   file { '/srv/fai/config/class/50-host-classes':
      ensure => file,
      source => 'puppet:///modules/puppet/class_50-host-classes',
      mode => '0755',
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   ###############
   # nfs exports #
   ###############
   nfs::server::nfsexport { 'fai_srv_export':
      path => '/srv/fai',
      options => ['async','ro','no_subtree_check','no_root_squash'],
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }

   # used to access parameters without PXE # 
   nfs::server::nfsexport { 'fai_tftp_export':
      path => '/srv/tftp',
      options => ['async','ro','no_subtree_check','no_root_squash'],
      require => [Package['fai-quickstart'], File['/srv/fai/config']],
   }     

   
   #############
   # fai hosts #
   #############

   if ! empty($debootstrap_list) {

      # !! fully managed !! #
      file { '/srv/tftp/fai/pxelinux.cfg':
         ensure => directory,
         recurse => true,
         purge => true,
         force => true,
         require => Puppet::Camaster::Fai::Debootstrap[$debootstrap_list],
      }

      file { '/srv/tftp/fai/pxelinux.cfg/default':
         ensure => present,
         require => Puppet::Camaster::Fai::Debootstrap[$debootstrap_list],
      }

      # configure host #
      $fai_hosts_list = keys($fai_hosts)
      puppet::camaster::fai::faihost { $fai_hosts_list:
         fai_hosts_hash => $fai_hosts,
         fai_debootstraps_hash => $fai_debootstraps,
         fai_host_file => '/srv/tftp/fai-hosts.conf',
         server => $casrv_dns,
         require => [Puppet::Camaster::Fai::Debootstrap[$debootstrap_list],File['/srv/tftp/fai/pxelinux.cfg','/srv/tftp/fai/pxelinux.cfg/default']],
      }
   }

   #############
   # fai tools #
   #############

   # fai monitor joind #
   file { '/usr/sbin/fai-monitor-joind':
      ensure => file,
      source => 'puppet:///modules/puppet/fai-monitor-joind',
      mode => '0744',
      require => Package['fai-quickstart'],
   }

   file { '/etc/systemd/system/fai-monitor-joind.service':
      ensure => file,
      source => 'puppet:///modules/puppet/fai-monitor-joind.service',
      mode => '0644',
      require => Package['fai-quickstart'],
   }

   file { '/usr/sbin/fai-join':
      ensure => file,
      source => 'puppet:///modules/puppet/fai-join',
      mode => '0744',
      require => Package['fai-quickstart'],
   }

   service { 'fai-monitor-joind':
      ensure => running,
      enable => true,
      require => File['/usr/sbin/fai-monitor-joind','/etc/systemd/system/fai-monitor-joind.service'],
   }

   # usb drive installer #
   file { '/usr/sbin/fai-usb-installer':
      ensure => file,
      source => 'puppet:///modules/puppet/fai-usb-installer',
      mode => '0744',
      require => Package['fai-quickstart'],
   }
}   
