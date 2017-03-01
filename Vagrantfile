# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('vars/vars.yml')
servers = settings["cluster"]

# node admin = first node in cluster dict
CephAdminNode = servers.keys[0]

CephAdminNodeConfig = servers.values[0]

Vagrant.configure("2") do |config|

	config.vm.box = "xenial2802201701"
	config.vm.synced_folder ".", "/vagrant", type: "nfs", disabled: "true"
	config.hostmanager.enabled = false
	config.hostmanager.manage_host = false
	config.hostmanager.manage_guest = true
	config.hostmanager.include_offline = false
	config.hostmanager.ignore_private_ip = false
     
	 config.vm.provision "ansible" do |common|
	  common.playbook = "ansible/playbooks/common.yml"
	  common.limit = "all"
	  common.sudo = true
	 end	

     puts "provisioning enviroment on all nodes" 	
      
     servers.each do |hostname, array|
	   config.vm.define hostname do |node|   		    
		   node.vm.hostname = hostname      
		    
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
		    
		    node.vm.provision :hostmanager
		  		    
			node.vm.provision "ansible" do |an|
			 an.playbook = "ansible/playbooks/setenv.yml"
			 an.sudo = true
			end	   
		end
	end
		
	puts "provisioning ceph admin node: #{CephAdminNode}"

    config.vm.define CephAdminNode do |node|   		       		
			node.vm.provision "ansible" do |an2|
			 an2.playbook = "ansible/playbooks/ceph_install.yml"
			 an2.extra_vars = { "CephAdminNode" => CephAdminNode }
			 an2.sudo = true
			end			
	
	end
	
end



