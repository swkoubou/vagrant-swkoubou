#!/bin/sh
set -eu
set -o vi

#third party repository setting
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum install centos-release-SCL
cd /etc/yum.repos.d/
wget http://people.centos.org/tru/devtools-2/devtools-2.repo
ls | grep -v -e "CentOS\|devtools" | xargs sed -i -e "s/enabled=1/enabled=0/g"
# sed -i -e "s/enabled=1/enabled=0/g" CentOS-SCL.repo
cd $HOME

# Install packages
yum -y --enablerepo=epel install httpd bash-completion vim man # TODO
yum -y install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
yum -y install python27 python33 nodejs010 mysql55
/sbin/chkconfig httpd on
/sbin/service httpd start
source /etc/profile.d/bash_completion.sh
PATH=$PATH:/opt/rh/devtoolset-2/root/usr/bin

# Disable iptables
/sbin/chkconfig iptables off
/sbin/service iptables stop

# Disable SELinux
/usr/sbin/setenforce 0
/bin/sed -i -e "s/SELINUX=permissive/SELINUX=disabled" /etc/selinux/config
