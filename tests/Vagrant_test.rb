# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('../vars/vars.yml')
cluster = settings["cluster"]

CephAllNode = []
CephOsdNode = []

cluster.each do |array|
 
 CephAllNode << array['node']
 
 if array.include? 'admnode'
  CephAdmNode = array['node']
 end
 
 if array.include? 'monnode'
  CephMonNode = array['node']
 end
 
 if array.include? 'osdnode'
  CephOsdNode << array['node']
 end
 	        
end 

# exit is admin node is not set
if CephAdmNode.empty?
 abort
end

# exit is osd node is not set
if CephOsdNode.empty?
 abort
end

# exit is no nodes
if CephAllNode.empty?
 abort
end

CephMonNode ||= CephAdmNode

    cluster.each do |array|
			array['network'].each do |net|
			        puts net['ipcluster']
					puts settings["cluster_network_name"]
					puts settings["cluster_netmask"]
		    end    
		        
     		array['osdnode'].each do |disk|
			  puts disk['size']
			  puts disk['dev']
			end 
   	end
	
