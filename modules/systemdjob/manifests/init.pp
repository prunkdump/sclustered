define systemdjob ( $script, $trigger, $description = $title, $randomize = undef, $ensure = present ) {

   # the systemd job script #
   file { "/usr/sbin/$name":
      ensure => $ensure,
      mode => '0755',
      content => $script,
   }

   # the systemd unit that run the script #
   file { "/lib/systemd/system/$name.service":
      ensure => $ensure,
      mode => '0644',
      content => template('systemdjob/systemd-job.service.erb'),
      require => File["/usr/sbin/$name"],
   }

   # the systemd timer #
   file { "/lib/systemd/system/$name.timer":
      ensure => $ensure,
      mode => '0644',
      content => template('systemdjob/systemd-job.timer.erb'),
      require => File["/usr/sbin/$name", "/lib/systemd/system/$name.service"],
   }

   # the systemd update #
   exec { "systemdjob_${name}_daemon-reload":
      path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe => File["/usr/sbin/$name", "/lib/systemd/system/$name.service", "/lib/systemd/system/$name.timer"],
   }

   # the timer status #
   if $ensure == "present" {
      $timerStatus = "running"
      $timerEnable = true
   } else {
      $timerStatus = "stopped"
      $timerEnable = false
   }

   service { "$name.timer":
      ensure => $timerStatus,
      enable => $timerEnable,
      require => [File["/usr/sbin/$name", "/lib/systemd/system/$name.service", "/lib/systemd/system/$name.timer"],
                  Exec["systemdjob_${name}_daemon-reload"]],
   }
} 
