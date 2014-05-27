#!/bin/sh
set -eu
set -o vi

#third party repository setting
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
cd /etc/yum.repos.d/
wget http://people.centos.org/tru/devtools-2/devtools-2.repo
ls | grep -v -e "CentOS\|devtools" | xargs sed -i -e "s/enabled=1/enabled=0/g"
cd $HOME

# Install packages
yum -y update
yum -y --enablerepo=epel,remi install httpd bash-completion vim man php postfix mysql nodejs
yum -y install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
/sbin/chkconfig httpd on
/sbin/service httpd start
source /etc/profile.d/bash_completion.sh
echo PATH=$PATH:/opt/rh/devtoolset-2/root/usr/bin >> /etc/profile
echo export PATH >> /etc/profile
source /etc/profile

# Python install
# STEP1 install needed package
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
# STEP2 install Python2.7.5
cd
wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.bz2
tar xvf Python-2.7.5.tar.bz2
cd Python-2.7.5
./configure --with-threads --enable-shared --prefix=/usr/local
make && make altinstall
rm -f Python-2.7.5.tar.bz2
ln -s /usr/local/lib/libpython2.7.so.1.0 /lib64/
# STEP3 install Python3.4.1
cd
wget http://www.python.org/ftp/python/3.4.1/Python-3.4.1.tar.xz
tar xvf Python-3.4.1.tar.xz
cd Python-3.4.1
./configure --with-threads --enable-shared --prefix=/usr/local
make && make altinstall
rm -f Python-3.4.1.tar.xz
ln -s /usr/local/lib/libpython3.4m.so.1.0 /lib64/
# STEP4 librally link
ln -s /usr/local/lib/libpython* /usr/lib
/sbin/ldconfig -v
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
ln -s /usr/local/include/python2.7 /usr/include/python2.7
ln -s /usr/local/include/python3.4 /usr/include/python3.4
# STEP5 sudo python to python2.7
sed -i -e "s/\(secure_path = \)\(\/sbin:\/bin:\/usr\/sbin:\/usr\/bin\)/\1\/usr\/local\/bin:\2/g" /etc/sudoers

# Disable iptables
/sbin/chkconfig iptables off
/sbin/service iptables stop

# Disable SELinux
/usr/sbin/setenforce 0
/bin/sed -i -e "s/SELINUX=permissive/SELINUX=disabled" /etc/selinux/config
