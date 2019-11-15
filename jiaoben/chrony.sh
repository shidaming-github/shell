#!/bin/bash
sed -i '6a server 192.168.4.254 iburst' /etc/chrony.conf
for i in client node2 node3
do
    scp /etc/chrony.conf $i:/etc
    ssh $i "systemctl restart chronyd"
done 
