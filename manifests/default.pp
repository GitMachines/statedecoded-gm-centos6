notify {"@ Super simple LAMP":}

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

file {'/var/www/html/statedecoded/htdocs/admin/import-data' :
  ensure => "directory",
  require  => Exec[ 'get-statedecoded' ],
}

# Until we figure out the .htaccess issue, copy over .htaccess version that works
file { '/var/www/html/statedecoded/htdocs/.htaccess':
  owner   => apache,
  group   => apache,
  mode    => 664,
  ensure  => present,
  require => Exec[ 'get-statedecoded' ],
  source  => "/vagrant/resources/.htaccess"
}

exec { 'pull-laws':
  # command  => '/usr/bin/wget http://vacode.org/downloads/code.xml.zip',
  command  => '/usr/bin/wget https://raw.github.com/GitMachines/statedecoded-gm-centos6-warehouse/master/vacode.org/2013/05/code-sample.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => File[ '/var/www/html/statedecoded/htdocs/admin/import-data' ],
}

exec { 'unzip-laws':
  # command  => '/usr/bin/unzip code.xml.zip',
  command => '/usr/bin/unzip code-sample.xml.zip',
  cwd      => '/var/www/html/statedecoded/htdocs/admin/import-data',
  require  => Exec[ 'pull-laws' ],
}
	
exec { 'get-statedecoded':
  command   => '/usr/bin/wget -S -O - https://github.com/statedecoded/statedecoded/archive/v0.81.tar.gz| /bin/tar zx --strip 1',
  # command   => '/usr/bin/wget -S -O - https://github.com/statedecoded/statedecoded/archive/master.tar.gz| /bin/tar zx --strip 1',
  cwd   => '/var/www/html/statedecoded',
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
  directories => [ { path => '/var/www/html/statedecoded', options => ['Indexes','FollowSymLinks','-MultiViews'], allow_override => ['All'] } ],
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
class { ['my_fw::pre', 'my_fw::post', 'my_fw::tomcat']: }
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

php::module { [ 'mysql', 'tidy', 'pear-Log', 'xml' ]: }

# Add php5 to Apache
class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini', }

exec{ 'get-java':
  command  => '/usr/bin/wget -S -O java.tar.gz --no-cookies --no-check-certificate --head  "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.tar.gz"',
  cwd  => '/opt', }

exec{ 'extract-java':
  command  => '/bin/tar -xzvf java.tar.gz',
  cwd => '/opt',
  require  => Exec[ 'get-java' ], }

exec{ 'create-exec-java':
  command => '/usr/sbin/alternatives --install /usr/bin/java java /opt/jdk1.7.0_45/bin/java 20000',
  cwd => '/opt',
  require  => Exec[ 'extract-java' ], }

# install tomcat & co.
package {["tomcat6", "tomcat6-webapps", "tomcat6-admin-webapps"]:
  ensure =>"present",
  require  => Exec[ 'create-exec-java' ], }

# start tomcat
service { "tomcat6":
  enable => "true",
  ensure => "running",
  hasrestart => "true",
  hasstatus => "true",
  require  => Package[ "tomcat6", "tomcat6-webapps", "tomcat6-admin-webapps" ], 
}

exec{ 'get-common-logging':
  command => '/usr/bin/wget -S http://apache.osuosl.org//commons/logging/binaries/commons-logging-1.1.3-bin.tar.gz',
  cwd => '/home/vagrant',
  require => Service[ 'tomcat6' ], }

exec{ 'extract-common-logging':
  command => '/bin/tar -xzvf commons-logging-1.1.3-bin.tar.gz',
  cwd => '/home/vagrant',
  require  => Exec[ 'get-common-logging' ], }

exec{ 'copy-common-logging':
  command => '/bin/cp commons-logging-*.jar /usr/share/tomcat6/lib',
  cwd  => '/home/vagrant/commons-logging-1.1.3',
  require  => Exec[ 'extract-common-logging' ], }

exec{ 'get-slf4j':
  command => '/usr/bin/wget -S http://www.slf4j.org/dist/slf4j-1.7.5.tar.gz',
  cwd => '/home/vagrant',
  require => Service[ 'tomcat6' ], }

exec{ 'extract-slf4j':
  command => '/bin/tar -xzvf slf4j-1.7.5.tar.gz',
  cwd => '/home/vagrant',
  require  => Exec[ 'get-slf4j' ], }

exec{ 'copy-slf4j':
  command => '/bin/cp slf4j-*.jar /usr/share/tomcat6/lib',
  cwd  => '/home/vagrant/slf4j-1.7.5',
  require  => Exec[ 'extract-slf4j' ], 
  timeout     => 420, }

exec{ 'get-solr':
  # command => '/usr/bin/wget http://apache.mirrors.lucidnetworks.net/lucene/solr/4.6.1/solr-4.6.1.tgz', # See issue #58
  # command => '/usr/bin/wget http://apache.mirrors.lucidnetworks.net/lucene/solr/4.5.1/solr-4.5.1.tgz', # See issue #56
  command => '/usr/bin/wget http://archive.apache.org/dist/lucene/solr/4.5.1/solr-4.5.1.tgz',
  cwd  => '/home/vagrant',
  require  => Package[ 'tomcat6','tomcat6-webapps','tomcat6-admin-webapps'],
  timeout     => 600, }
#require  => Service[ 'tomcat6' ], }

exec { 'untar-solr':
  command => '/bin/tar -xzvf solr-4.5.1.tgz',
  cwd => '/home/vagrant',
  require => Exec[ 'get-solr' ], }

exec { 'copy-webxml':
  command => '/bin/cp -r /vagrant/resources/WEB-INF .',
  cwd => '/home/vagrant/solr-4.5.1/dist', 
  require => Exec[ 'untar-solr' ], }

exec { 'replace-webxml':
  command => '/opt/jdk1.7.0_45/bin/jar -uf ./solr-4.5.1.war WEB-INF/web.xml',
  cwd => '/home/vagrant/solr-4.5.1/dist',
  require => Exec[ 'copy-webxml' ], }

exec { 'copy-solr':
  command => '/bin/cp solr-4.5.1.war /usr/share/tomcat6/webapps/solr.war',
  cwd => '/home/vagrant/solr-4.5.1/dist',
  require => Exec[ 'replace-webxml' ],
}

file { [ "/home/solr/" ] :
   ensure => "directory",
}

exec{ 'copy-solr-home':
  command => '/bin/cp -r /var/www/html/statedecoded/solr_home/* /home/solr/',
  cwd => '/home/solr',
  require => [File[ '/home/solr' ], Exec ['mount-shared'] ],
}

exec { 'mount-shared-solr':
        command         => '/bin/umount /home/solr; /bin/echo "/home/solr      /home/solr      vboxsf   uid=`id -u tomcat`,gid=`id -g tomcat`   0 0" >> /etc/fstab; /bin/mount /home/solr',
        require         => Exec['copy-solr']
}
