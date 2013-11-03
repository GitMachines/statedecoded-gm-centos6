/*
{ "gmdoc": {
     "note": "This file must be in the puppets module directory on the virtual machine.",
     "puppet_file_path": "/etc/puppet/modules/my_fw/manifests/solr.pp"
   }
}
*/
 
class my_fw::solr {
  Firewall {
    require => undef,
  }

  # Solr firewall rules

  firewall { '100 allow solr access':
    port   => [8983],
    proto  => tcp,
    action => accept,
  }

}