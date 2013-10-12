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
class { 'mysql::server': }

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}

php::ini { '/etc/httpd/conf/php.ini':
  mail_add_x_header => 'Off',
  # For the parent directory
  require => Package['httpd'],
}

class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini' }

class { 'git': }

vcsrepo { '/var/www/html/statedecoded/':
    ensure   => latest,
    user     => $user,
    provider => git,
    require  => Package["git"],
    source   => "git@github.com:statedecoded/statedecoded.git",
    revision => 'master',
  }

/*
 { "gmdoc": {
 	"title": "Capture basic report",
   }
 }
*/
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}