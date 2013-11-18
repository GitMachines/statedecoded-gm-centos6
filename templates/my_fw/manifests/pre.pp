/*
{ "gmdoc": {
     "note": "This file must be in the puppets module directory on the virtual machine.",
     "puppet_file_path": "/etc/puppet/modules/my_fw/manifests/pre.pp"
   }
}
*/
 
class my_fw::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }

  /* Accept everything on localhost loopback */
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
 
  firewall { '002 INPUT allow loopback':
      iniface => 'lo',
      chain   => 'INPUT',
      action    => accept,
  }

  firewall { '002 INPUT allow related and established':
      state => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
      proto => 'all',
  }

  firewall { '100 allow ssh':
      state => ['NEW'],
      dport => '22',
      proto => 'tcp',
      action  => 'accept',
  }

  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }

}