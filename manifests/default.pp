notify {"@ Super simple LAMP":}

class{ 'epel': }

# { "gmdoc": "https://gist.github.com/gregelin/6857377" }
class { 'apache':  }

##apache::mod { 'rewrite': }
apache::vhost { 'statedecoded.dev':
  docroot       => '/var/www/html/statedecoded',
  port          => '80',
}

apache::mod { 'php': }

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
class { 'mysql::server': }

/*
 { "gmdoc": {
 	"title": "Capture basic report",
   }
 }
*/
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}

#class { 'php': 
#  service => 'apache',
#  require => Class['apache'],
#}

php::module { 'mysql': }
php::module { 'cli': }
php::module { 'curl': }
php::module { 'intl': }
#php::module { 'mcrypt': }
#php::module { 'mysqlnd': }
php::module { 'tidy': }
php::module { 'devel': }

#class { 'php::devel':
#  require => Class['php'],
#}

#class { 'php::pear':
#  require => Class['php'],
#}

# Installation of solr
# install open-jdk 1.6
#package{"java-1.6.0-openjdk-devel":
#  ensure=>latest
#}

# install tomcat & co.
#package {["tomcat6", "tomcat6-webapps", "tomcat6-admin-webapps"]:
#  ensure =>"present"
#}


