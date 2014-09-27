#!/bin/sh

# PATH
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin

# yum config setting
sed -i "\$a include\_only\=\.jp" /etc/yum/pluginconf.d/fastestmirror.conf
sed -i -e "
    s/^mirror/\#mirror/
    s/^\#base/base/
    s/\(^base.*\)mirror\.centos\.org\(.*$\)/\1ftp.iij.ad.jp\/pub\/linux\2/
    " /etc/yum.repos.d/CentOS-Base.repo
yum clean all

#third party repository setting
echo "##### third party repository setting #####";
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
cd /etc/yum.repos.d/
wget http://people.centos.org/tru/devtools-2/devtools-2.repo
ls | grep -v -e "CentOS\|devtools" | xargs sed -i -e "s/enabled=1|enabled = 1/enabled=0/g"
cd $HOME

# Install packages
echo "##### Install packages #####"
yum -y update
yum -y --enablerepo=epel,remi install httpd bash-completion vim man php postfix mysql nodejs git
yum -y install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
echo "export PATH=/usr/local/bin:$PATH:/opt/rh/devtoolset-2/root/usr/bin" >> /etc/bashrc
export PATH=/usr/local/bin:$PATH:/opt/rh/devtoolset-2/root/usr/bin

# httpd on
echo "##### httpd on #####"
/sbin/chkconfig httpd on
/sbin/service httpd start

# bashrc setting
cat << EOF >> /home/vagrant/.bashrc
export EDITOR=vim
EOF

# Local time setting
\cp -fp /usr/share/zoneinfo/Japan /etc/localtime

