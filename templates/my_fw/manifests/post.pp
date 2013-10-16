/*
{ "gmdoc": {
     "note": "This file must be in the puppets module directory on the virtual machine.",
     "puppet_file_path": "/etc/puppet/modules/my_fw/manifests/post.pp"
   }
}
*/
 
class my_fw::post {

  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }

}