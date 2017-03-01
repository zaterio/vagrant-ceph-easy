# vagrant-ceph-easy
Easy multimode Ceph cluster running on Vagrant (libvirt)

## Install prerequisites

* [Vagrant](http://www.vagrantup.com/downloads.html)
* libvirt + qemu + virt tools on host machine
* [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)
* [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
* [Ansible](https://www.ansible.com/)


## Configuring Ceph
Edit vars/vars.yml variables and cluster dict, example:

```json
cluster:
 ceph-1:
   ip_cluster: "192.168.101.101"
   osd:
    osd0:
     disk: /dev/vdb
     mount: /usr/local/osd0
    osd1:
     disk: /dev/vdc
     mount: /usr/local/osd1 
 ceph-2:
   ip_cluster: "192.168.101.102"
   osd:
    osd2:
     disk: /dev/vdb
     mount: /usr/local/osd2
    osd3:
     disk: /dev/vdc
     mount: /usr/local/osd3
    osd4:
     disk: /dev/vdd
     mount: /usr/local/osd4
 ceph-3:
   ip_cluster: "192.168.101.103"
   osd:
    osd5:
     disk: /dev/vdb
     mount: /usr/local/osd5
    osd6:
     disk: /dev/vdc
     mount: /usr/local/osd6
    osd7:
     disk: /dev/vdd
     mount: /usr/local/osd7
```
will install 3 node ceph cluster, with admin node = ceph-1 (first key in dict).
