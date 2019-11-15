#!/bin/bash
#设置读写分离,host1写服务器,host2读服务器,host3为Maxscale代理服务器
#客户端访问代理服务器IP地址:mysql -h(代理服务器的ip) -P(读写分离服务的端口4006) -u(主服务器添加的访问数据的用户) -p(主服务器添加的访问数据的用户密码)
host1=192.168.4.201
host2=192.168.4.203
host3=192.168.4.200
#配置主从服务器,主host1,从host2
for i in $host1 $host2
do
 scp -o StrictHostKeyChecking=no /linux-soft/03/mysql/mysql-5.7.17.tar root@$i:/root
 ssh -X root@$i "tar -xf mysql-5.7.17.tar
                 yum -y install mysql*.rpm
                 systemctl start mysqld
                "
 ssh -X root@$i 'mysqladmin -uroot -p"$(grep -w root@localhost: /var/log/mysqld.log | tail -1 | cut -d " " -f 11)" password "123qqq...A"'
done
#host1服务器设为主,host2为从,主从服务器添加监控用户和路由用户及密码,主服务器添加访问数据的用户和密码,创建共享库
ssh -X root@$host1 " sed -i \"4a server_id=${host1##*.}\nlog-bin=master${host1##*.}\" /etc/my.cnf;
                     systemctl restart mysqld;
                     mysql -uroot -p123qqq...A -e \"grant replication slave on *.* to repluser@'%' identified by '123qqq...A';
                     grant replication slave,  replication client on *.* to maxscalemon@'%' identified by '123qqq...A';
                     grant  select on mysql.* to maxscalerouter@'%' identified by '123qqq...A'; 
                     create database db1;
                     grant select,insert on  db1.* to yaya@'%' identified by '123qqq...A'\"
                   "
ssh -X root@$host2 "
                    sed -i \"4a server_id=${host2##*.}\"  /etc/my.cnf;  
                    systemctl restart mysqld;
                    mysql -uroot -p123qqq...A -e \" change master to  master_host='$host1',master_user='repluser',master_password='123qqq...A',master_log_file='master${host1##*.}.000001',master_log_pos=441;
                    start slave;
                    grant replication slave,  replication client on *.* to maxscalemon@'%' identified by '123qqq...A';
                    grant  select on mysql.* to maxscalerouter@'%' identified by '123qqq...A';
                    show slave status\G \" |grep -i yes
                   
                   "
#配置host3Maxscale代理-->下载地址:https://downloads.mariadb.com/files/maxscale ,这里是真机拷贝给host3主机
scp -o StrictHostKeyChecking=no /linux-soft/03/mysql/maxscale-2.1.2-1.rhel.7.x86_64.rpm  root@$host3:/root/
ssh -X root@$host3 "rpm -ivh maxscale-2.1.2-1.rhel.7.x86_64.rpm;
                    sed -i \"10s/1/auto/;20s/127.0.0.1/$host1/;33s/$/,server2/;34s/myuser/maxscalemon/;35s/mypwd/123qqq...A/;47,53s/^/#/;61s/$/,server2/;62s/myuser/maxscalerouter/;63s/mypwd/123qqq...A/;80,84s/^/#/;23a [server2]\ntype=server\naddress=$host2\nport=3306\nprotocol=MySQLBackend\" /etc/maxscale.cnf;
                    sed -i \" 101a port=4016\" /etc/maxscale.cnf;
                    maxscale -f /etc/maxscale.cnf;
                    netstat -utnlp  | grep maxscale
                   "
#在代理上查看授权用户:监控用户和路由用户
#ssh root@$host3 "yum -y install mariadb
#                  mysql -h$host1 -umaxscalemon -p123qqq...A
#                  mysql -h$host2 -umaxscalemon -p123qqq...A
#                  mysql -h$host1 -umaxscalerouter -p123qqq...A
#                  mysql -h$host2 -umaxscalerouter -p123qqq...A
#                 "
