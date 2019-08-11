class desktop::xfce::config {

   # !!! need to be checked !!!

   #file { '/etc/X11/default-display-manager':
   #   ensure => file,
   #   content => "/usr/sbin/lightdm\n",
   #   mode => '0644',
   #}

   #file { '/etc/alternatives/x-session-manager':
   #   ensure => link,
   #   target => '/usr/bin/startxfce4',
   #}

   # disable login prompt to select interface #
   #file {'/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml':
   #  ensure => file,
   #  source => "puppet:///modules/desktop/xfce4-panel.xml",
   #  mode => '0644',
   #}

}
