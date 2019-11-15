#!/bin/bash
#导出文件里的用户名并创建用户
for i in `cat /opt/user.txt`
do
 useradd $i 
done

