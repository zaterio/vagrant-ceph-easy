# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

config.vm.box = "cheGGo/ubuntu-xenial64"
config.vm.synced_folder ".", "/vagrant", type: "nfs", disabled: "true"
config.hostmanager.enabled = true
config.hostmanager.manage_host = true
config.hostmanager.manage_guest = true
config.hostmanager.include_offline = false
config.hostmanager.ignore_private_ip = false

	config.vm.define "node-1" do |node|

	    node.vm.hostname = "node-1"   
	    
	    node.vm.network :public_network,
	      :ip => "192.168.122.2",
	      :dev => "virbr0",
	      :mode => "bridge",
	      :type => "bridge"
	      
	    node.vm.network :private_network, 
	        :ip => "192.168.101.2",
	        :libvirt__dhcp_enabled => "false",
	        :libvirt__forward_mode => "none",
	        :libvirt__network_name => "ceph_cluster_network",
	        :libvirt__netmask => "255.255.255.0"    
	         
	    node.vm.provider :libvirt do |v|
	     v.cpus = 1
	     v.memory = 1024
	     v.nested = true
	    end     	    
	    
		node.vm.provision :hosts do |provisioner|
	      provisioner.autoconfigure = true
	      provisioner.sync_hosts = true
	      provisioner.add_host '192.168.122.2', ['node-1']
	    end
	end
	
	config.vm.define "node-2" do |node|

	    node.vm.hostname = "node-2"   
	    
	    node.vm.network :public_network,
	      :ip => "192.168.122.3",
	      :dev => "virbr0",
	      :mode => "bridge",
	      :type => "bridge"
	      
	    node.vm.network :private_network, 
	        :ip => "192.168.101.3",
	        :libvirt__dhcp_enabled => "false",
	        :libvirt__forward_mode => "none",
	        :libvirt__network_name => "ceph_cluster_network",
	        :libvirt__netmask => "255.255.255.0"    
	         
	    node.vm.provider :libvirt do |v|
	     v.cpus = 1
	     v.memory = 1024
	     v.nested = true
	    end     	    
	end	
	

	
	
end

