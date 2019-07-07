class pammount {

   anchor { 'pammount::begin': }->
   class { 'pammount::install': }->
   class { 'pammount::config': }->
   anchor { 'pammount::end': }

}
