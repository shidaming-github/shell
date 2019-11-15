#!/bin/bash
ssh-keygen -f /root/.ssh/id_rsa -N ''
for i in 10 11 12 13
do
   ssh-copy-id 192.168.4.$i
done
