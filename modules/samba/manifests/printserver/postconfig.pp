class samba::printserver::postconfig (
   $adservice,
   $short_domain,
) {

   ######################
   # create directories #
   ######################

   file { ['/srv/samba/Printer_drivers',
           '/srv/samba/Printer_drivers/COLOR',
           '/srv/samba/Printer_drivers/IA64',
           '/srv/samba/Printer_drivers/W32ALPHA',
           '/srv/samba/Printer_drivers/W32MIPS',
           '/srv/samba/Printer_drivers/W32PPC',
           '/srv/samba/Printer_drivers/WIN40',
           '/srv/samba/Printer_drivers/x64',
           '/srv/samba/Printer_drivers/W32X86',
           '/srv/samba/Printer_drivers/W32X86/2',
           '/srv/samba/Printer_drivers/W32X86/3']:
      ensure => directory,
      group => "$short_domain\\domain admins",
      mode => '2755',
      require => Service[$adservice],
   }

}
