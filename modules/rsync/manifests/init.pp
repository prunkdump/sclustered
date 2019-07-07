class rsync {

   # just install client #
   anchor { 'rsync::begin': } ->
   class { 'rsync::install': } ->
   anchor { 'rsync::end': } 

}
