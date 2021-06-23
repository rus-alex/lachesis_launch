#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e


N=$((NODES-1))

for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i
    ssh ${NAME}$i "sudo -u opera bash -c 'cd /home/opera/ && ./txsgen initbalance &> txsgen0.log'"
done

