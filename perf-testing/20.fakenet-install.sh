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
    scp -r ./opera ${NAME}$i:/tmp/opera/
done


# make dedicated user
for i in `seq 0 $N`; do
    ssh ${NAME}$i "sudo useradd opera; sudo mv /tmp/opera /home/opera; sudo chown -R opera:opera /home/opera"
done


# configure and run service
for i in `seq 0 $N`; do
    ssh ${NAME}$i "sudo ln -s /home/opera/opera-node.service /etc/systemd/system/opera-node.service; sudo systemctl daemon-reload && sudo systemctl restart opera-node"
done
