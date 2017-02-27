# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

 config.vm.define :ceph do |ceph|
    ceph.vm.box = "cheGGo/ubuntu-xenial64"
    ceph.vm.hostname = "ceph"
    ceph.vm.synced_folder ".", "/vagrant", type: "nfs"
    ceph.vm.network :forwarded_port, guest: 80, host: 4567
    ceph.vm.network :private_network, :ip => "10.20.30.40"
    ceph.vm.provider :libvirt do |v|
     v.cpus = 1
     v.memory = 1024
     v.nested = true
    end

 #   ceph.vm.provision "ansible" do |an|
 #    #an.verbose = "v"
 #    an.playbook = "playbooks/ceph.yml"
 #    an.extra_vars = { ansible_ssh_user: 'vagrant' }
 #    an.sudo = true
 #   end

 end
end
