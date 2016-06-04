#!/bin/sh

if [ ! `id -u` == 0 ];then
    echo pls run as root !
    exit 1
fi

RDO_RELEASE=rdo-release-icehouse-4.noarch.rpm
RDO_DIR=openstack-icehouse/
RDO_ROOT=https://repos.fedorapeople.org/repos/openstack/

# #选择一台CentOS服务器，安装以下软件：
# yum -y install yum-utils createrepo yum-plugin-priorities
# yum -y install httpd

# #设置httpd
# chkconfig httpd on
# service httpd start

#获取repo文件并使用reposync同步源
# if [ -e $RDO_DIR/$RDO_RELEASE ]; then
#     RDO_URL=$RDO_DIR/$RDO_RELEASE
# else
#     RDO_URL=$RDO_RDOT/$RDO_DIR/$RDO_RELEASE
# fi
# yum -y install $RDO_URL
# yum repolist #可以看到源的id列表

#同步openstack-icehouse这个repo
cd /var/www/html/
reposync --repoid=openstack-icehouse
# 
# #第一次同步时间较长，同步结束后
# createrepo –update /var/www/html/openstack-icehouse

# #此处若使用其他目录下的文件夹的符号链接到/var/www/html处，需要关闭SELinux的安全选项
# setenforce 0
# 
# #添加以下内容到其中已有的22端口这条规则的下面
# sed -i.backup 's/\(-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT\)/\1\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT/' /etc/sysconfig/iptables
exit 0
