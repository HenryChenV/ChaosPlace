#!/bin/bash

if [ ! `id -u` = 0 ];then
    echo pls run as root ~
    exit 1
fi


# settings
echo Import Setting File
SETTING_FILE=settings.conf
if [ ! -e $SETTING_FILE ]; then
    echo Do NOT find settings file !
    exit 1
fi
. ./$SETTING_FILE
CWD=$PWD

echo


# change network settings
echo Change Network Settings
sed -i"" 's/dhcp/static/' $IFCFG_ETH0_FILE
cat >> $IFCFG_ETH0_FILE << EOF
IPADDR=$IPADDR
NETMASK=$NETMASK
NETWORK=$NETWORK
GATEWAY=$GATEWAY
DNS1=$DNS1
EOF
echo Backup...
cp -v /etc/sysconfig/network-scripts/ifcfg-eth0{,.bak}
mv $IFCFG_ETH0_FILE /etc/sysconfig/network-scripts/
service network restart

echo 192.168.30.9 repo.henry.chen >> $HOSTS_FILE
echo Backup...
mv -v /etc/$HOSTS_FILE{,.bak}
mv $HOSTS_FILE /etc/$HOSTS_FILE

echo $IFCFG_ETH0_FILE
cat $IFCFG_ETH0_FILE
echo $HOSTS_FILE
cat $HOSTS_FILE

echo


# change repos and makecache
echo Change Repos and Makecache
for REPO in ${REPOS[@]}
do
    if [ -e $SYS_REPO_DIR/$REPO ];then
        echo Backup $REPO
        mv -v $SYS_REPO_DIR/$REPO{,.bak}
    fi
    echo Change repo: $REPO
    cp -v $CWD/$LOCAL_REPO_DIR/$REPO $SYS_REPO_DIR
done
yum -y makecache

echo


# installing...
echo Installing...
getenforce
setenforce 0
getenforce

yum -y install openstack-packstack
packstack --gen-answer-file=answer.conf
sed -i "s/_PW=[0-9a-z]\+/_PW=maxwit/" answer.conf
packstack --answer-file=answer.conf

echo


# Finished
echo Enjoy it !

echo
exit 0
