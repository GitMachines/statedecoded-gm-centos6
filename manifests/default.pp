notify {"@ Super simple LAMP":}

class { 'epel': }

# Until we figure out a better way
exec { 'mount-shared':
	command		=> '/bin/umount /var/www/html/statedecoded; /bin/echo "/var/www/html/statedecoded      /var/www/html/statedecoded      vboxsf   uid=`id -u apache`,gid=`id -g apache`   0 0" >> /etc/fstab; /bin/mount /var/www/html/statedecoded',
	require		=> Class['apache']
}

file { '/var/www/html/statedecoded/includes/config.inc.php':
  owner   => apache,
  group   => apache,
  mode    => 775,
  ensure  => present,
  require => exec[ 'mount-shared' ],
  source  => "/vagrant/resources/config.inc.php"
}

file { '/var/www/html/statedecoded/includes/class.Virginia.inc.php':
  owner   => apache,
  group   => apache,
  mode    => 775,
  ensure  => present,
  require => exec[ 'mount-shared' ],
  source  => "/vagrant/resources/class.Virginia.inc.php"
}

exec {'make-dataimport':
  command  => '/bin/mkdir /var/www/html/statedecoded/htdocs/admin/import-data',
  require  => exec[ 'mount-shared' ],
}

exec { 'pull-laws':
  command  => '/usr/bin/wget http://vacode.org/downloads/code.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => exec[ 'make-dataimport' ],
}

exec { 'unzip-laws':
  command  => '/usr/bin/unzip code.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => exec[ 'pull-laws' ],
}
	
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
