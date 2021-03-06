# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	# All Vagrant configuration is done here. The most common configuration
	# options are documented and commented below. For a complete reference,
	# please see the online documentation at vagrantup.com.
	
	config.vm.box = "centos-64-x64-vbox4210"
	config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
	config.vm.hostname = "statedecoded-gm-centos6"
	
	# network config from statedecoded
	config.vm.network :private_network, ip: "192.168.56.101"
	config.vm.network :forwarded_port, guest: 80, host: 8080
        config.vm.network :forwarded_port, guest: 8080, host:8081	
	# Install puppet modules
	config.vm.provision :shell, :path => "librarian.sh"
	
	# Set up synched folder for working on StateDecoded on the host (Also ensures the directory is created)
	config.vm.synced_folder "statedecoded/", "/var/www/html/statedecoded", id: "vagrant-root", create: true
	config.vm.synced_folder "solr/", "/home/solr", id: "vagrant-root", create: true         
	
	# Run our puppet modules
	config.vm.provision "puppet" do |puppet|
		puppet.options = "--modulepath '/etc/puppet/modules'"
		puppet.manifests_path = "manifests"
		puppet.manifest_file = "default.pp"
	end

	# Restart Apache & Tomcat
	config.vm.provision :shell, :path => "misc/scripts/restart-services.sh"

	# Install scap
	config.vm.provision :shell, :path => "audit/resources/scripts/scap-install.sh"

	# Run simple scap test
	config.vm.provision :shell, :path => "audit/resources/scripts/oscap-rhel6-test2.sh"

	# Run stig-rhel6-server scap test
	config.vm.provision :shell, :path => "audit/resources/scripts/oscap-rhel6.sh"

	# Import sample laws
	# Comment out the below line to prevent automatica importing of sample laws from Virginia
	config.vm.provision :shell, :path => "misc/scripts/import-sample-laws.sh"

end
