#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e


N=$((NODES-1))
cd ${SRC}/build/${NAME}

for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i STOP
    ssh ${NAME}$i "sudo systemctl stop opera-node"
done


for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i START
    ssh ${NAME}$i "cd /home/opera && sudo rm -fr fakenet && sudo systemctl start opera-node"
done
