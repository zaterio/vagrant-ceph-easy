# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('vars/vars.yml')
cluster = settings["cluster"]

CephAllNode = []
CephOsdNode = []
CephMonNode = []

cluster.each do |array|
 
 CephAllNode << array['node']
 
 if array.include? 'admnode' and not defined? CephAdmNode
  CephAdmNode = array['node']
 end
 
 if array.include? 'monnode'
  CephMonNode << array['node']
 end
 
 if array.include? 'osdnode'
  CephOsdNode << array['node']
 end
 	        
end 

# exit is admin node osd nodes or no node defined
if not defined? CephAdmNode or CephOsdNode.empty? or CephAllNode.empty?
 abort
end

puts  CephMonNode
CephMonNode ||= CephAdmNode

Vagrant.configure("2") do |config|

	config.vm.box = "xenial2802201701"
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
			        :libvirt__network_name => settings["public_network_name"],
			        :libvirt__netmask => settings["public_network_netmask"]
		    end    
		        
		        
		    node.vm.provider :libvirt do |v|
		     v.cpus = 1
		     v.memory = 512
		     v.nested = true
			 v.keymap = "es"
			 v.volume_cache = "none"
			 array['osdnode'].each do |disk|
			  v.storage :file, :size => disk['size'], 
						:dev => disk['dev'], 
						:cache => 'none', 
						:bus => 'virtio',
						:type => 'qcow2'
			 end
		    end
		    
		    node.vm.provision :hostmanager
		  		    
			node.vm.provision "ansible" do |an|
			 an.playbook = "ansible/playbooks/setenv.yml"
			 an.sudo = true
			end	   
	
		end
	end

	config.vm.define CephAdmNode do |adm|   		       		
	 adm.vm.provision "ansible" do |an|
	  an.sudo = true
	  an.playbook = "ansible/playbooks/ceph_install.yml"
	  an.extra_vars = { "CephAdmNode" => CephAdmNode, 
						"CephMonNode" => CephMonNode, 
						"CephAllNode" => CephAllNode,  
						"CephOsdNode" => CephOsdNode 
					  }
	 end
	end 
end
	
