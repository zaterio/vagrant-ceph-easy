# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
#require 'ipaddress'
settings = YAML.load_file('vars/vars.yml')
cluster = settings["cluster"]


#ip = IPAddress(settings["public_network"])
public_network_netmask = "255.255.255.0"
cluster_network_netmask = "255.255.255.0"

CephAllNode = []
CephOsdNode = []
CephMonNode = []
cephOsdCount = 0

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
		for osd in array['osdnode']
			if osd.include? 'dev'
				cephOsdCount += 1
			end
		end 
	end        
end 

# exit is admin node osd nodes or no node defined
if not defined? CephAdmNode or CephOsdNode.empty? or CephAllNode.empty?
 abort
end

CephMonNode ||= CephAdmNode

CephNonAdmNode = CephAllNode.clone
CephNonAdmNode.delete(CephAdmNode)

if CephNonAdmNode.empty?
 abort
end 


if not defined? settings['public_network']
 public_network = "192.168.100.0/24"
end

if not defined? settings['public_network_name']
 public_network_name = "public_network"
end


if not defined? cluster_network 
 cluster_network = "192.168.100.0/24"
end

if not defined? cluster_network_name
 public_network_name = "cluster_network"
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
			
		    node.vm.provider :libvirt do |v|
				v.cpus = 1
				v.memory = 512
				v.nested = true
				v.keymap = "es"
				v.volume_cache = "none"
				array['osdnode'].each do |disk|
					if disk['size'] < 10
						disk['size'] = 10
					end
					v.storage	:file, :size => "#{disk['size']}G", :dev => disk['dev'], :cache => 'none', :bus => 'virtio', :type => 'qcow2'
				end
		    end
		    
		    if defined? array['network']['public_network_ip'] and defined? settings["public_network_name"]
			 node.vm.network :private_network, 
								:ip => array['network']['public_network_ip'],
								:libvirt__dhcp_enabled => "false",
								:libvirt__guest_ipv6 => "no",
								:libvirt__forward_mode => "none",
								:libvirt__network_name => settings["public_network_name"],
								:libvirt__netmask => public_network_netmask
			else
			 node.vm.network :private_network, 
								:libvirt__dhcp_enabled => "true",
								:libvirt__guest_ipv6 => "no",
								:libvirt__forward_mode => "none",
								:libvirt__network_name => public_network_name
		    end
			

			 
			 if defined? array['network']['cluster_network_ip'] and defined? settings["cluster_network_name"]
			  node.vm.network :private_network, 
								:ip => array['network']['cluster_network_ip'],
								:libvirt__dhcp_enabled => "false",
								:libvirt__guest_ipv6 => "no",
								:libvirt__forward_mode => "none",
								:libvirt__network_name => settings["cluster_network_name"],
								:libvirt__netmask => cluster_network_netmask
			end
			 
    		node.vm.provision :hostmanager	    
		  		    
			node.vm.provision "ansible" do |an|
			 an.playbook = "ansible/playbooks/setenv.yml"
			 an.sudo = true
			end	   
	
		end
	end



	cluster.each do |array|
		if array['node']  == CephAdmNode
			config.vm.define CephAdmNode do |node|   		       		
				node.vm.provision "ansible" do |an|
					an.sudo = true
					an.playbook = "ansible/playbooks/ceph_install.yml"
					an.extra_vars = { "CephAdmNode" => CephAdmNode, 
						"CephMonNode" => CephMonNode, 
						"CephAllNode" => CephAllNode,  
						"CephOsdNode" => CephOsdNode, 
					    "CephNonAdmNode" => CephNonAdmNode,
					    "CephOsdCount" => cephOsdCount}
				end
			end
		end	 
	end
end	
