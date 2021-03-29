#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh

N=$((NODES-1))


for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i
    ssh ${NAME}$i "
cd /home/lachesis/lachesis
sudo ./lachesis attach --exec \"admin.peers.length\" lachesis.ipc
sudo ./lachesis attach --exec \"admin.nodeInfo.enode\" lachesis.ipc
"
done
