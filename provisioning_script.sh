#!/bin/sh
set -eu
set -o vi

#third party repository setting
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
cd /etc/yum.repos.d/
ls | grep -v CentOS | xargs sed -i -e "s/enabled=1/enabled=0/g"
cd $HOME

# Install packages
yum -y --enablerepo=epel install httpd bash-completion vim
/sbin/chkconfig httpd on
/sbin/service httpd start
source /etc/profile.d/bash_completion.sh

# Disable iptables
/sbin/chkconfig iptables off
/sbin/service iptables stop

# Disable SELinux
/usr/sbin/setenforce 0
/bin/sed -i -e "s/SELINUX=permissive/SELINUX=disabled" /etc/selinux/config