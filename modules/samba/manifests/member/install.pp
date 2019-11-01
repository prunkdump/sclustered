class samba::member::install {

   #################
   # main packages #
   #################

   # acl packages #
   package { ['samba','acl']:
      ensure => installed,
   }

   # kerberos packages #
   package { krb5-user:
      ensure => installed,
   }

   # quota tools #
   # NOT NEEDED
   #package { ['quota','quotatool']:
   #   ensure => installed,
   #}
}
