notify {"@ Super simple LAMP":}

# { "gmdoc": "https://gist.github.com/gregelin/6857377" }
class { 'apache': }


# { "gmdoc": "https://gist.github.com/gregelin/6858369"}
resources { "firewall":
  # remove existing firewall rules
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre']
}
class { ['my_fw::pre', 'my_fw::post']: }
class { 'firewall': }


# { "gmdoc": "https://gist.github.com/gregelin/6857258" }
# class { 'mysql::server': }

/*
 { "gmdoc": {
 	"title": "Capture basic report",
   }
 }
*/
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}