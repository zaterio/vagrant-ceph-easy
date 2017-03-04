# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file('../vars/vars.yml')
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

CephMonNode ||= CephAdmNode

CephNonAdmNode = CephAllNode.clone
CephNonAdmNode.delete(CephAdmNode)


puts "CephNonAdmNode #{CephNonAdmNode}"
puts "CephAllNode #{CephAllNode}"
puts "mon: #{CephMonNode}"

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
	
