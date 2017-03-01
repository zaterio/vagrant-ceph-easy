# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('vars/vars.yml')

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
   
	config.vm.define "#{settings['nodebase']}-1" do |ceph1|
		    ceph1.vm.hostname = "#{settings['nodebase']}-1"       
		    ceph1.vm.network :private_network, 
		        :ip => "#{settings['cluster_network']}.101",
		        :libvirt__dhcp_enabled => "false",
		        :libvirt__forward_mode => "none",
		        :libvirt__network_name => "ceph_cluster_network",
		        :libvirt__netmask => "255.255.255.0"    
		    ceph1.vm.provider :libvirt do |v|
		     v.cpus = 1
		     v.memory = 1024
		     v.nested = true
			 v.keymap = "es"
			 v.volume_cache = "none"
			 v.storage :file, :size => '20G', :cache => 'none'
			 v.storage :file, :size => '20G', :cache => 'none'
		    end
		    
		    ceph1.vm.provision :hostmanager
		  		    
			ceph1.vm.provision "ansible" do |an|
			 an.playbook = "ansible/playbooks/setenv.yml"
			 an.sudo = true
			end
			
			#ceph1.vm.provision "ansible" do |an2|
			 #an2.playbook = "ansible/playbooks/ceph1.yml"
			 #an2.sudo = true
			#end

	end
	
	config.vm.define "#{settings['nodebase']}-2" do |ceph2|
		    ceph2.vm.hostname = "#{settings['nodebase']}-2"   	    
		    ceph2.vm.network :private_network, 
		        :ip => "#{settings['cluster_network']}.102",
		        :libvirt__dhcp_enabled => "false",
		        :libvirt__forward_mode => "none",
		        :libvirt__network_name => "ceph_cluster_network",
		        :libvirt__netmask => "255.255.255.0"    	         
		    ceph2.vm.provider :libvirt do |v|
		     v.cpus = 1
		     v.memory = 1024
		     v.nested = true
			 v.keymap = "es"
			 v.volume_cache = "none"
			 v.storage :file, :size => '20G', :cache => 'none'
			 v.storage :file, :size => '20G', :cache => 'none'
		    end
		    
		    ceph2.vm.provision :hostmanager  
		    
		    ceph2.vm.provision "ansible" do |an|
			 an.playbook = "ansible/playbooks/setenv.yml"
			 an.sudo = true
			end 
	end	
 end





