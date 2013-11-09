/*
{ "gmdoc": {
     "note": "This file must be in the puppets module directory on the virtual machine.",
     "puppet_file_path": "/etc/puppet/modules/my_fw/manifests/tomcat.pp"
   }
}
*/
 
class my_fw::tomcat {
  Firewall {
    require => undef,
  }

  # Tomcat/Solr firewall rules

  firewall { '100 allow tomcat access for solr':
    port   => [8080],
    proto  => tcp,
    action => accept,
  }

}