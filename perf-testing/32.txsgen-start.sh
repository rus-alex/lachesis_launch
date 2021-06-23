#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e


N=$((NODES-1))

for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i
    if (( $i % 2 )); then
        ssh ${NAME}$i "sudo -u opera bash -c 'cd /home/opera/; nohup ./txsgen calls &'"
    else
        ssh ${NAME}$i "sudo -u opera bash -c 'cd /home/opera/; nohup ./txsgen transfers &'"
    fi    
done

