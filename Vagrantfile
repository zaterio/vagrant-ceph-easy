# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('vars/vars.yml')
cluster = settings["cluster"]

CephAdminNodes = []

cluster.each do |array|
 if array.include? 'admin'
  CephAdminNodes << array['node']
 end 
 array['network'].each do |net|
  if net.include? 'ipcluster'
  end
 end
end

Vagrant.configure("2") do |config|

	config.vm.box = "xenial0103201702"
	config.vm.synced_folder ".", "/vagrant", type: "nfs", disabled: "true"
	config.hostmanager.enabled = false
	config.hostmanager.manage_host = false
	config.hostmanager.manage_guest = true
	config.hostmanager.include_offline = false
	config.hostmanager.ignore_private_ip = false

    cluster.each do |array|
      
	   config.vm.define array['node'] do |node|   		    
		   node.vm.hostname =  array['node']     

			array['network'].each do |net|
			    node.vm.network :private_network, 
			        :ip => net['ipcluster'],
			        :libvirt__dhcp_enabled => "false",
			        :libvirt__guest_ipv6 => "no",
			        :libvirt__forward_mode => "none",
			        :libvirt__network_name => settings["cluster_network_name"],
			        :libvirt__netmask => settings["cluster_netmask"]
		    end    
		        
		        
		    node.vm.provider :libvirt do |v|
		     v.cpus = 1
		     v.memory = 512
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


	cluster.each do |array|
	 if array.include? 'admin'
	    CephAdminNode = array['node']
		config.vm.define CephAdminNode do |admnode|   		       		
				    admnode.vm.provision "ansible" do |an2|
					 an2.playbook = "ansible/playbooks/ceph_install.yml"
					 an2.extra_vars = { "CephAdminNode" => CephAdminNode }
					 an2.sudo = true
					end
		end
	 end 
	end
end		
