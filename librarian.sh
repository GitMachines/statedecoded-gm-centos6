which librarian-puppet > /dev/null
if [ $? -ne 0 ]
then
	echo "librarian-puppet-maestrodev not installed, installing"
	gem install librarian-puppet-maestrodev --no-ri --no-rdoc
fi

cp /vagrant/Puppetfile* /etc/puppet

# Copy firewall module manifests
mkdir -p /etc/puppet/modules/my_fw/manifests
cp /vagrant/templates/my_fw/manifests/pre.pp /etc/puppet/modules/my_fw/manifests/
cp /vagrant/templates/my_fw/manifests/post.pp /etc/puppet/modules/my_fw/manifests/
cp /vagrant/templates/my_fw/manifests/solr.pp /etc/puppet/modules/my_fw/manifests/

cd /etc/puppet

librarian-puppet install
