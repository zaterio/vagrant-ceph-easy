# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'ipaddress'

settings = YAML.load_file('../vars/vars.yml')
cluster = settings["cluster"]

CephAllNode = []
CephOsdNode = []
CephMonNode = []
cephOsdCount = 0

ip = IPAddress(settings["public_network"])
p ip.netmask
#ip_public = IPAddress::IPv4.new #{public_network}


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

p "osds = #{cephOsdCount}"

# exit is admin node osd nodes or no node defined
if not defined? CephAdmNode or CephOsdNode.empty? or CephAllNode.empty?
 abort
end

CephMonNode ||= CephAdmNode

CephNonAdmNode = CephAllNode.clone
CephNonAdmNode.delete(CephAdmNode)



cluster.each do |array|
p array['network']['public_network_ip']
p array['network']['cluster_network_ip']
end

	
