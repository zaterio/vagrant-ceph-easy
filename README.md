# vagrant-ceph-easy
Easy multimode Ceph cluster running on Vagrant (libvirt)

## Install prerequisites

* [Vagrant](http://www.vagrantup.com/downloads.html)
* libvirt + qemu + virt tools on host machine
* [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)
* [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
* [Ansible](https://www.ansible.com/)

## Tested
* ubuntu xenial (guests and host)

## Configuring Ceph
Edit vars/vars.yml variables and cluster dict, example:

```json
cluster:
   - node: ceph1
     admin: true
     network:
        - ipcluster: "192.168.101.101"
     osd:
        - name: osd0
          disk: /dev/vdb
          mount: /usr/local/osd0
        - name: osd1
          disk: /dev/vdc
          mount: /usr/local/osd1
    
   - node: ceph2
     network:
        - ipcluster: "192.168.101.102"
     osd:
       - name: osd2
         disk: /dev/vdb
         mount: /usr/local/osd2
       - name: osd3
         disk: /dev/vdc
         mount: /usr/local/osd3
       - name: osd4
         disk: /dev/vdd
         mount: /usr/local/osd4
    
   - node: ceph3 
     network: 
        - ipcluster: "192.168.101.103"
     osd:
       - name: osd5
         disk: /dev/vdb
         mount: /usr/local/osd5
       - name: osd6
         disk: /dev/vdc
         mount: /usr/local/osd6
       - name: osd7
         disk: /dev/vdd
         mount: /usr/local/osd7
```
will install 3 node ceph cluster, with admin node = ceph-1 (first key in dict).
