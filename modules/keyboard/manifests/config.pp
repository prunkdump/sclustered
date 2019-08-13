class keyboard::config {

   $model = $keyboard::model
   $layout = $keyboard::layout
   $variant = $keyboard::variant
   $options = $keyboard::options

   if $model {
      file_option { 'keyboard_model':
         path => '/etc/default/keyboard',
         option => 'XKBMODEL',
         value => "\"${model}\"",
         separator => '=',
         multiple => false,
         ensure => present,
      }
   }

   if $layout {
      file_option { 'keyboard_layout':
         path => '/etc/default/keyboard',
         option => 'XKBLAYOUT',
         value => "\"${layout}\"",
         separator => '=',
         multiple => false,
         ensure => present,
      }
   }

   if $variant {
      file_option { 'keyboard_variant':
         path => '/etc/default/keyboard',
         option => 'XKBVARIANT',
         value => "\"${variant}\"",
         separator => '=',
         multiple => false,
         ensure => present,
      }
   }


   if $options {
      file_option { 'keyboard_options':
         path => '/etc/default/keyboard',
         option => 'XKBOPTIONS',
         value => "\"${options}\"",
         separator => '=',
         multiple => false,
         ensure => present,
      }
   }
}
