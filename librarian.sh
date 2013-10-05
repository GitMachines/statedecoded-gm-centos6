which librarian-puppet > /dev/null
if [ $? -ne 0 ]
then
	echo "librarian-puppet-maestrodev not installed, installing"
	gem install librarian-puppet-maestrodev
fi

cp /vagrant/Puppetfile* /etc/puppet

cd /etc/puppet

librarian-puppet install
