#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e


N=$((NODES-1))
cd ${SRC}/build/${NAME}

# copy files to servers
for i in `seq 0 $N`; do
    ssh ${NAME}$i "mkdir -p /tmp/opera"
    scp -r ./node$i/* ${NAME}$i:/tmp/opera
    #scp -r ./opera ${NAME}$i:/tmp/opera/
done

# configure and run service
for i in `seq 0 $N`; do
    ssh ${NAME}$i "sudo systemctl stop opera-node; sudo mv /tmp/opera/* /home/opera/ && sudo chown -R opera:opera /home/opera/ && sudo systemctl daemon-reload && sudo systemctl start opera-node"
done
