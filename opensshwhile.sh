#!/bin/bash
:<<! 
注意： : %s/openssh-8.1p1/openssh-8.1p1/g
1.使用脚本前需要在命令行模式下更改文本模式set ff=unix ;  
2. 执行完脚本后，请执行source /etc/profile;
3. 请在/root下执行脚本
4.如出现openssl升级后找不到库文件，可通过查找openssl库文件解决。//find  /  -name  "libssl*”  echo  "/usr/local/lib64"   >>   /etc/ld.so.conf   ldconfig -v
关闭enforce和firewalld,配置时区和时间服务chrony,加固SSH服务centos7,配置DNS,初始化镜像用户和安全。设置root密码为SHun@Cloud.icom，添加用户SHunicom，并将其密码设置为ShCX#9+2uc0$]80! 
!
language(){
        echo $LANG |grep -q zh
        if [ $? -eq 0 ];then
                return 0
        else
                return 1
        fi
}

#Define a user portal menu.
menu(){
	clear
	language
	if [ $? -eq 0 ];then
	   echo "  ##############----Menu----##############"
	   echo "# 1. CENTOS 6 升级Openssh"
	   echo "# 2. CENTOS 7 升级Openssh"
	   echo "# 3. CENTOS 6 升级Openssh(nossl)"
	   echo "# 4. CENTOS 7 升级Openssh(nossl)"
	   echo "# 5. UBUNTU16 升级Openssh"
	   echo "# 6. 初始化镜像模板"
	   echo "# 7. 退出程序"
	   echo "  ########################################"
	else
	   echo "  ##############----Menu----##############"
	   echo "# 1. CENTOS 6   upgrade Openssh 8.1"
	   echo "# 2. CENTOS 7   upgrade Openssh 8.1"
	   echo "# 3. CENTOS 6(nossl)  upgrade Openssh 8.1"
	   echo "# 4. CENTOS 7(nossl)  upgrade Openssh 8.1"
	   echo "# 5. Ubuntu  16  upgrade Openssh 8.1"
           	   echo "# 6. init linux system secrity"
	   echo "# 7. Exit Program"
	   echo "  ########################################"
	fi
}

#Read user's choice
choice(){
	language
	if [ $? -eq 0 ];then
		read -p "请选择一个菜单[1-5]:" select
	else
		read -p "Please choice a menu[1-5]:" select
	fi
}



zlic_install () {
         cd /root
         tar  -vxf zlib-1.2.11.tar.gz
         cd zlib-1.2.11
         ./configure   --prefix=/usr/local/zlib
         make  &&  make install
         echo " zlib install ok"
}

openssl_install () {
         cd /root 
         tar  -vxf openssl-1.1.1a.tar.gz >/dev/null
         cd openssl-1.1.1a
         ./config  shared  zlib  --prefix=/usr/local/openssl
         make  &&  make install
         \mv  /usr/bin/openssl  /usr/bin/openssl.old
         \mv  /usr/include/openssl  /usr/include/openssl.old
         ln  -s  /usr/local/openssl/bin/openssl   /usr/bin/openssl
         ln  -s  /usr/local/openssl/include/openssl   /usr/include/openssl
         echo  "/usr/local/openssl/lib"   >>   /etc/ld.so.conf
         ldconfig -v
}


openssh_prepare () {
       yum -y install wget
       rpm -qa |grep wget
       wget_stat=$?
       ping -c  3 openbsd.hk
       ping_stat=$?
     
      if [[ $ping_stat -eq 0 ]] && [[ $wget_stat -eq 0 ]];then
             wget http://openbsd.hk/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz
             wget "https://www.openssl.org/source/openssl-1.1.1a.tar.gz"
             wget http://www.zlib.net/zlib-1.2.11.tar.gz
             
             yum install  -y gcc gcc-c++ glibc make autoconf openssl openssl-devel pcre-devel  pam-devel tcp_wrappers-devel wget
      else
            echo -n -e "program:  'basename $wget_stat'  openssh download faifled"
      fi
     ps -ef |grep sshd | grep -v grep
     ssh_stat=$?
     rpm -qa |grep openssh
     openssh_stat=$?
     if [[ $ssh_stat = 0 ]] && [[ $openssh_stat = 0 ]];then
          systemctl stop sshd
          rpm -qa |grep openssh |xargs -d "\n" rpm -e --nodeps
          \mv /etc/init.d/sshd /etc/init.d/sshd.bak
          \mv /etc/ssh /etc/ssh.bak
     elif [ $ssh_stat -eq 0 -a $openssh_stat -ne 0 ]  ;then  
          systemctl stop sshd
         \mv /usr/local/openssh /usr/local/openssh.bak
     elif [ $ssh_stat -ne 0 -a $openssh_stat -ne 0 ]  ;then
           \mv /usr/local/openssh /usr/local/openssh.bak
     elif [ $ssh_stat -ne 0 -a $openssh_stat -eq 0 ]  ;then
          rpm -qa |grep openssh |xargs -d "\n" rpm -e --nodeps
          \mv /etc/init.d/sshd /etc/init.d/sshd.bak
          \mv /etc/ssh /etc/ssh.bak
     fi
}

ubuntu_prepare () {
        echo "0" >/etc/apt-get/sources.list
       sed -i '1a  deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse ' /etc/aptt/sources.list
       sed -i '1a  deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse' /etc/apt/sources.list
       sed -i '1a  deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' /etc/apt/sources.list
       sudo apt-get install wget
       dpkg -s wget
       wget_stat=$?
       ping -c  3 openbsd.hk
       ping_stat=$?
     
      if [[ $ping_stat -eq 0 ]] && [[ $wget_stat -eq 0 ]];then
             wget http://openbsd.hk/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz
             wget "https://www.openssl.org/source/openssl-1.1.1a.tar.gz"
             wget http://www.zlib.net/zlib-1.2.11.tar.gz
            sudo apt-get install wget gcc make zlib1g-dev libssl-dev libpam0g-dev sysv-rc-conf -y
      else
            echo -n -e "program:  'basename $wget_stat'  openssh download faifled"
      fi
     ps -ef |grep sshd | grep -v grep
     ssh_stat=$?
     rpm -qa |grep openssh
     openssh_stat=$?
     if [[ $ssh_stat = 0 ]] && [[ $openssh_stat = 0 ]];then
          systemctl stop sshd
          \mv /etc/init.d/sshd /etc/init.d/sshd.bak
          \mv /etc/ssh /etc/ssh.bak
     elif [ $ssh_stat -eq 0 -a $openssh_stat -ne 0 ]  ;then  
          systemctl stop sshd
         \mv /usr/local/openssh /usr/local/openssh.bak
     elif [ $ssh_stat -ne 0 -a $openssh_stat -ne 0 ]  ;then
           \mv /usr/local/openssh /usr/local/openssh.bak
     elif [ $ssh_stat -ne 0 -a $openssh_stat -eq 0 ]  ;then
          \mv /etc/init.d/sshd /etc/init.d/sshd.bak
          \mv /etc/ssh /etc/ssh.bak
     fi
 }

openssh_install () {
         cd /root
         tar -xvf openssh-8.1p1.tar.gz &&  /root > /dev/null
         cd openssh-8.1p1
         var="$1"
         if [ "$var" = "cen6" ];then
             ./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-privsep-path=/var/lib/sshd --with-pam --with-ssl-dir=/usr/local/openssl -with-md5-passwords --without-hardening 
             if [ $? = 0 ];then
                  openssh_init
             else
                  echo "system is $var , configure openssh failed " >>/install.log
             fi
         elif [ "$var" = "cen7" ];then
            ./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-md5-passwords --with-privsep-path=/var/lib/sshd --with-pam --with-ssl-dir=/usr/local/openssl
             if [ $? = 0 ];then
                  openssh_init
             else
                  echo "system is $var , configure openssh failed " >>/install.log
             fi
          elif [ "$var" = "cen6nossl" ];then
             ./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-privsep-path=/var/lib/sshd --with-pam -with-md5-passwords --without-hardening 
             if [ $? = 0 ];then
                  openssh_init
             else
                  echo "system is $var , configure openssh failed " >>/install.log
             fi
           elif [ "$var" = "cen7nossl" ];then
            ./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-md5-passwords --with-privsep-path=/var/lib/sshd --with-pam
             if [ $? = 0 ];then
                  openssh_init
             else
                  echo "system is $var , configure openssh failed " >>/install.log
             fi
         fi
}        

openssh_init () {
               make && make install
               \cp $DIRSSH/contrib/redhat/sshd.init /etc/init.d/sshd
              sed -i '25,25s/SSHD=\/usr\/sbin\/sshd/SSHD=\/usr\/local\/openssh\/sbin\/sshd/' /etc/init.d/sshd
              sed -i '41,41s/\/usr\/bin\/ssh-keygen -A/\/usr\/local\/openssh\/bin\/ssh-keygen -A/' /etc/init.d/sshd
              chkconfig --add sshd && systemctl daemon-reload
              \cp /etc/ssh.bak/sshd_config   /etc/ssh/sshd_config 
              \chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key
              systemctl start sshd
              echo "export PATH=/usr/local/openssh/bin:$PATH" >> /etc/profile 
              source /etc/profile
              ln -s /usr/local/openssh/bin/ssh /sbin/ssh
}

system_init () {
                sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
                setenforce 0
                sed -i 's/#Port 22/Port 22022' /etc/ssh/sshd_config
                sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
                sed -i '1a nameserver 114.114.114.114' /etc/resolv.conf
                sed -i '1a options timeout:1 attempts:1 rotate' /etc/resolv.conf
               echo SHun@Cloud.icom |passwd --stdin root
               yum -y install wget net-tools httpd-tools sysstat lsof tree
            if [ $? = 0 ];then
                systemctl stop firewalld && systemctl disable firewalld
            else 
                echo "firewalld is off "
            fi

            zone=$(timedatectl |grep Asia/Shanghai)
            if [ $? != 0 ];then
                timedatectl set-timezone Asia/Shanghai
           else
                echo "Time zone configuration successful"
            fi
           rpm -qa |grep chrony
            if [ $? != 0 ];then
                yum -y install chrony && \cp /etc/chrony.conf /etc/chrony.conf.bak
                sed -i '/^server/ s/^/#/' /etc/chrony.conf
                sed -i '2a server ntp.ntsc.ac.cn iburst' /etc/chrony.conf
                chronyc -a makestep
           else
                echo "chrony is sucess"
           fi
            id SHunicom
           if [ $? != 0 ];then
                 useradd SHunicom && echo ShCX#9+2uc0$]80\! |passwd --stdin SHunicom
                echo "SHunicom add ok"
           fi
}

DIRZLIB='/usr/local/zlib'
DIRSSL='/usr/local/openssl'
DIRSSH='/root/openssh-8.1p1'
INSTALLSSH='/usr/local/openssh'
SYSSSH='/etc/ssh'
while :
do
menu
choice
case $select in
1)
	  openssh_prepare
                  zlic_install
                  openssl_install
                  openssh_install cen6
                  exit
                  ;;
2)
	 openssh_prepare
                 zlic_install
                 openssl_install
                 openssh_install cen7
                 exit
                 ;;
3)
	  openssh_prepare
                  zlic_install
                  openssl_install
                  openssh_install cen6nossl
                  exit
                  ;;
4)
	 openssh_prepare
                 zlic_install
                 openssl_install
                 openssh_install cen7nossl
                 exit
                 ;;
5)
	ubuntu_prepare 
                zlic_install
                openssl_install
                openssh_install   cen7
                exit    
                ;;
6)
                system_init
                exit
                 ;;
7)
	exit
	;;
*)
	echo Sorry!
esac
done







