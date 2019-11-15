#!/bin/bash
#设置主从服务器
host1=192.168.4.201
host2=192.168.4.203
for i in $host1 $host2
do
 scp -o StrictHostKeyChecking=no /linux-soft/03/mysql/mysql-5.7.17.tar root@$i:/root
 ssh -X root@$i "tar -xf mysql-5.7.17.tar
                 yum -y install mysql*.rpm
                 systemctl start mysqld
                "
 ssh -X root@$i 'mysqladmin -uroot -p"$(grep -w root@localhost: /var/log/mysqld.log | tail -1 | cut -d " " -f 11)" password "123qqq...A"'
done
#host1服务器设为主,host2为从
ssh -X root@$host1 " sed -i \"4a server_id=${host1##*.}\nlog-bin=master${host1##*.}\" /etc/my.cnf
                     systemctl restart mysqld
                     mysql -uroot -p123qqq...A -e \"grant replication slave on *.* to repluser@'%' identified by '123qqq...A'\"
                   "
ssh -X root@$host2 "
                    sed -i \"4a server_id=${host2##*.}\"  /etc/my.cnf  
                    systemctl restart mysqld
                    mysql -uroot -p123qqq...A -e \" change master to  master_host='$host1',master_user='repluser',master_password='123qqq...A',master_log_file='master${host1##*.}.000001',master_log_pos=441;
                    start slave;
                    show slave status\G \" |grep -i yes
                   
                   "

