notify {"@ Super simple LAMP":}

class{ 'epel': }

# { "gmdoc": "https://gist.github.com/gregelin/6857377" }
class { 'apache':  }

apache::vhost { 'statedecoded.dev':
  vhost_name    => '*',
  docroot       => '/var/www/html/statedecoded/htdocs/',
  port          => '80',
  default_vhost => true,
}

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

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}

php::ini { '/etc/httpd/conf/php.ini':
  mail_add_x_header => 'Off',
  # For the parent directory
  require => Class['apache'],
}

class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini' }

php::module { [ 'mysql', 'tidy' ]: }
