#!/bin/bash


DST_DIR=$1

CUR_DIR=`pwd`

if [ ! ${DST_DIR} ];
then
    DST_DIR=.
fi

echo "Pull all projects in ${DST_DIR}"

for PRJ in `ls ${DST_DIR}`;
do 
    PRJ_DIR=${DST_DIR}/${PRJ}
    if [ ! -d ${PRJ_DIR} ]; 
    then
        continue
    fi

    echo [${PRJ}]

    if [ -d ${PRJ_DIR}/.git ]; then
        cd ${PRJ_DIR}
        echo `pwd`
        git pull
        cd ${CUR_DIR}
    else
        echo "Not git repo, skip."
    fi

    echo
done
