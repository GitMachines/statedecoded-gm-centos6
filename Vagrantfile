# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	# All Vagrant configuration is done here. The most common configuration
	# options are documented and commented below. For a complete reference,
	# please see the online documentation at vagrantup.com.
	
	config.vm.box = "centos-64-x64-vbox4210"
	config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
	
	# network config from statedecoded
	config.vm.network :private_network, ip: "192.168.56.101"
	config.vm.network :forwarded_port, guest: 80, host: 8080

	# network config Solr
	config.vm.network :forwarded_port, guest: 8983, host: 8984
	config.vm.synced_folder "./modules/solr", "/etc/puppet/modules/solr"
	
	# Install puppet modules
	config.vm.provision :shell, :path => "librarian.sh"
	
	# Set up synched folder for working on StateDecoded on the host (Also ensures the directory is created)
	config.vm.synced_folder "statedecoded/", "/var/www/html/statedecoded", id: "vagrant-root", create: true
	
	# Run our puppet modules
	config.vm.provision "puppet" do |puppet|
		# puppet.options = "--modulepath '/etc/puppet/modules'"
		puppet.module_path = "modules"
    	puppet.manifests_path = "manifests"
		puppet.manifest_file = "default.pp"
    	puppet.options = ['--verbose']
	end
end
