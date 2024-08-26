class wolenable {

   anchor { 'wolenable::begin': } ->
   class { 'wolenable::install': } ~>
   class { 'wolenable::service': } ->
   anchor { 'wolenable::end': }

}
