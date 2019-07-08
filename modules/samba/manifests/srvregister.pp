define samba::srvregister ($service = $title, $ensure = present, $update = true) {

   # add the line to dns update list #
   file_line { "insert_samba_dns_$service" :
      path => "$samba::private_path/dns_update_list",
      line => "A                      ${service}.\${DNSDOMAIN}                                     \$IP",
      match => "^\\s*A\\s*${service}",
      ensure => $ensure,
      multiple => false,
   }

   # update dns #
   if $update == true {
      exec { "samba_dns_update_$service":
         command => "samba_dnsupdate",
         path => '/usr/bin:/usr/sbin:/bin',
         subscribe => File_line["insert_samba_dns_$service"],
         refreshonly => true,
         require => [File_line["insert_samba_dns_$service"],Class['samba::dcservice']],
      }
   }
}
   


