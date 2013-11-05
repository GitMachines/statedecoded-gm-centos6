notify {"@ Super simple LAMP":}
$statedecoded_home = "/var/www/html/statedecoded"

class { 'epel': }

# Until we figure out a better way
exec { 'mount-shared':
	command		=> '/bin/umount /var/www/html/statedecoded; /bin/echo "/var/www/html/statedecoded      /var/www/html/statedecoded      vboxsf   uid=`id -u apache`,gid=`id -g apache`   0 0" >> /etc/fstab; /bin/mount /var/www/html/statedecoded',
	require		=> Exec['get-statedecoded']
}

# create a directory  
file { [ "/var/www/html/statedecoded/", "/var/www/html/statedecoded/htdocs/" ] :
   ensure => "directory",
}

file { '/var/www/html/statedecoded/includes/config.inc.php':
  owner   => apache,
  group   => apache,
  mode    => 775,
  ensure  => present,
  require => Exec[ 'get-statedecoded' ],
  source  => "/vagrant/resources/config.inc.php"
}

file { '/var/www/html/statedecoded/includes/class.Virginia.inc.php':
  owner   => apache,
  group   => apache,
  mode    => 775,
  ensure  => present,
  require => Exec[ 'get-statedecoded' ],
  source  => "/vagrant/resources/class.Virginia.inc.php"
}

exec {'make-dataimport':
  command  => '/bin/mkdir /var/www/html/statedecoded/htdocs/admin/import-data',
  require  => Exec[ 'get-statedecoded' ],
}

exec { 'pull-laws':
  command  => '/usr/bin/wget http://vacode.org/downloads/code.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => Exec[ 'make-dataimport' ],
}

exec { 'unzip-laws':
  command  => '/usr/bin/unzip code.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => Exec[ 'pull-laws' ],
}
	
exec { 'get-statedecoded':
	command		=> '/usr/bin/wget -S -O - https://github.com/statedecoded/statedecoded/archive/master.tar.gz| /bin/tar zx --strip 1',
	cwd		=> '/var/www/html/statedecoded',
	require         => Class['apache'],
}

#exec { 'unzip-statedecoded':
#  command => '/usr/bin/unzip master;/bin/mv statedecoded-master statedecoded; /bin/rm master',
#  cwd     => '/var/www/html',
#  require => Exec[ 'get-statedecoded' ],
#}

# Install and define apache
class { 'apache': }

# Add the statedecoded VHost to apache
apache::vhost { 'statedecoded.dev':
  vhost_name    => '*',
  docroot       => '/var/www/html/statedecoded/htdocs/',
  directories => [ { path => '/var/www/html/statedecoded', options => ['Indexes','FollowSymLinks','MultiViews'], allow_override => ['All'] } ],
  port          => '80',
  default_vhost => true,
  override => 'all',
  require       => Exec['get-statedecoded']
}

resources { "firewall":
  # remove existing firewall rules
  purge => true
}

Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre']
}
class { ['my_fw::pre', 'my_fw::post', 'my_fw::solr']: }
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

# Write configuration facts to file /tmp/facts.yaml
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

php::module { [ 'mysql', 'tidy', 'pear-Log' ]: }

# Add php5 to Apache
class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini' }

# solr install
file {"solr_home":
    name => "${home}/solr_home",
    ensure => directory,
    recurse => true,
    purge => true,
    source => "/vagrant/src/solr_home",
    mode => '0644',
} ->

# package { 'default-jdk': 
#     ensure => 'installed',
# } ->

# install open-jdk 1.6
package{"java-1.6.0-openjdk-devel":
  ensure=>latest
} ->

# We have to install solr last since it needs a working solr home
class { "solr::jetty":
    solr_home => "${statedecoded_home}/solr_home"
}
