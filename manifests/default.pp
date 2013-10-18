notify {"@ Super simple LAMP":}

class { 'epel': }

# Until we figure out a better way
exec { 'get-statedecoded':
	command		=> '/usr/bin/wget -S -O - https://github.com/statedecoded/statedecoded/archive/v0.7.tar.gz | /bin/tar zx --strip 1',
	cwd		=> '/var/www/html/statedecoded',
	require         => Class['apache']
}

exec { 'chmod':
  command => '/bin/chown -R apache:apache /var/www/html/statedecoded',
  require => exec['get-statedecoded'],
}

# Install and define apache
class { 'apache': }

# Add the statedecoded VHost to apache
apache::vhost { 'statedecoded.dev':
  vhost_name    => '*',
  docroot       => '/var/www/html/statedecoded/htdocs/',
  port          => '80',
  default_vhost => true
}

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

# Install and define MySQL
class { 'mysql::server':
	service_enabled	=> true
}

mysql::db { 'statedecoded':
	user		=> 'statedecoded',
	password	=> 'statedecoded',
	host		=> 'localhost',
	grant		=> 'ALL'
}

mysql::db { 'statedecoded2':
        user            => 'statedecoded',
        password        => 'statedecoded',
        host            => 'localhost.localdomain',
        grant           => 'ALL'
}


file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}

# Install and define php
php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}

php::ini { '/etc/httpd/conf/php.ini':
  mail_add_x_header => 'Off',
  # For the parent directory
  require => Class['apache'],
}

php::module { [ 'mysql', 'tidy' ]: }

# Add php5 to Apache
class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini' }
