#!/bin/bash
echo -e "[mon] \nname=mon \nbaseurl=ftp://192.168.4.254/ceph/MON \ngpgcheck=0" >> /etc/yum.repos.d/ceph.repo
echo -e "[osd] \nname=osd \nbaseurl=ftp://192.168.4.254/ceph/OSD \ngpgcheck=0" >> /etc/yum.repos.d/ceph.repo
echo -e "[tools] \nname=tools \nbaseurl=ftp://192.168.4.254/ceph/Tools \ngpgcheck=0" >> /etc/yum.repos.d/ceph.repo
for i in client node2 node3
do
 scp /etc/yum.repos.d/ceph.repo $i:/etc/yum.repos.d/
done
