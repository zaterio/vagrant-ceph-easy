# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('vars/vars.yml')
cluster = settings["cluster"]

CephAdminNode = []

cluster.each do |array|
 if array.include? 'admin'
 CephAdminNode << array['node']
 end
end



Vagrant.configure("2") do |config|

	config.vm.box = "elastic/ubuntu-16.04-x86_64"
	config.vm.synced_folder ".", "/vagrant", type: "nfs", disabled: "true"
	config.hostmanager.enabled = false
	config.hostmanager.manage_host = false
	config.hostmanager.manage_guest = true
	config.hostmanager.include_offline = false
	config.hostmanager.ignore_private_ip = false
     
    
     cluster.each do |array|
       
	   config.vm.define array['node'] do |node|   		    
		   node.vm.hostname =  array['node']     
		    
		    node.vm.network :private_network, 
		        :ip => array['ip_cluster'],
		        :libvirt__dhcp_enabled => "false",
		        :libvirt__forward_mode => "none",
		        :libvirt__network_name => settings["cluster_network_name"],
		        :libvirt__netmask => settings["cluster_netmask"]
		    
		    node.vm.provider :libvirt do |v|
		     v.cpus = 1
		     v.memory = 1024
		     v.nested = true
			 v.keymap = "es"
			 v.volume_cache = "none"
			 array['osd'].each do |o|
			  v.storage :file, :size => '20G', :cache => 'none'
			 end
		    end      
		    
		    
		end
	end
end		
