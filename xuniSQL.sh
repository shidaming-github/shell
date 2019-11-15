#!/bin/bash
host1=192.168.4.99
scp -o StrictHostKeyChecking=no /linux-soft/03/mysql/mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz root@$host1:/root
ssh -X root@$host1 "tar -zxvf mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz;
                    yum -y install libaio;
                    PATH=/usr/local/mysql/bin/:\$PATH;
                    echo \"export PATH=/usr/local/mysql/bin:\$PATH\" >> /etc/bashrc;
                    useradd mysql &> /dev/null;
                    mv mysql-5.7.20-linux-glibc2.12-x86_64 /usr/local/mysql;
                    mv /etc/my.cnf /root/ &> /dev/null;
                    mkdir /dir1;
                    mkdir /dir2;
                    echo -e \"[mysqld_multi]\nmysqld=/usr/local/mysql/bin/mysqld_safe\nmysqladmin=/usr/local/mysql/bin/mysqladmin\nuser=root\n[mysqld1]\ndatadir=/dir1\nport=3307\nlog-error=/dir1/mysql3307.log\npid-file=/dir1/mysql3307.pid\nsocket=/dir1/mysql3307.sock\n[mysqld2]\ndatadir=/dir2\nport=3308\nlog-error=/dir2/mysql3308.log\npid-file=/dir2/mysql3308.pid\nsocket=/dir2/mysql3308.sock\" > /etc/my.cnf;
                    mysqld_multi  start 1 &> /root/a.txt;
                    mysqld_multi  start 2 &> /root/b.txt;
                   "
#登录虚拟数据库后用alter user 修改密码:/usr/local/mysql/bin/mysql -uroot -p'初始密码' -S  /dir1/mysql3307.sock
#此命令可以停止服务:/usr/local/mysql/bin/mysqld_multi  --user=root --password=123456  stop 1

