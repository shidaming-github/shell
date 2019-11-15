#!/bin/bash
echo -e "192.168.4.10 client \n 192.168.4.11 node1 \n 192.168.4.12 node2 \n 192.168.4.13 node3" >> /etc/hosts
for i in client node2 node3
do
  scp /etc/hosts $i:/etc/
done
