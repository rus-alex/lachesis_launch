#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh


N=$((NODES-1))

for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i
    ssh ${NAME}$i "cd /home/opera && sudo ./opera --exec debug.ttfReport\(ftm.blockNumber,10,\'arrival_time\',0\) attach opera.ipc"
done
