#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e

N=$((NODES-1))
cd ${SRC}/build/${NAME}

for i in `seq 0 $N`; do
    j=$(((i+1) % NODES))

    echo Connect ${NAME}$i to ${NAME}$j
    ENODE=$(ssh ${NAME}$j "cd /home/opera && sudo ./opera attach -exec 'admin.nodeInfo.enode' ./opera.ipc")
    echo "enode = ${ENODE}"
    ssh ${NAME}$i "cd /home/opera && sudo ./opera attach -exec 'admin.addPeer(${ENODE})' ./opera.ipc"
done

