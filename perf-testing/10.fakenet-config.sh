#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e

# configs
cp ./cfg/*.* ${SRC}/build/${NAME}/

N=$((NODES-1))
cd ${SRC}/build/${NAME}
# make service config
for i in `seq 0 $N`; do
    IP=$(ssh -G ${NAME}$i | grep "^hostname" | awk '{print $2}')
    mkdir -p node$i
    cat << CFG > node$i/opera-node.service
[Unit]
Description=opera validator node
After=network.target auditd.service

[Service]
Type=simple
User=opera
Group=opera
WorkingDirectory=/home/opera
ExecStart=/home/opera/opera --fakenet=$((i+1))/$((N+1)) --datadir=. --nousb \
    --nat="extip:${IP}" --port=7946 \
    --ws --ws.addr="127.0.0.1" --ws.port=4500 --ws.origins="*" --ws.api="eth,debug,admin,web3,personal,txpool,ftm,sfc"
OOMScoreAdjust=-900

[Install]
WantedBy=multi-user.target
Alias=opera.service

CFG
done


# note and exit
cat << NOTE

Configs 'node<N>/opera-node.service'
    are generated in ${SRC}/build/${NAME}

Put 'opera' binaries into ${SRC}/build/${NAME}/, then
run next step
    './20.fakenet-install.sh'

NOTE
