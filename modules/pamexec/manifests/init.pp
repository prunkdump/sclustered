class pamexec {

   anchor { 'pamexec::begin': }->
   class { 'pamexec::install': }->
   class { 'pamexec::config': }->
   anchor { 'pamexec::end': }

}
