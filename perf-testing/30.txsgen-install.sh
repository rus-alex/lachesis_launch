#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh


N=$((NODES-1))
cd ${SRC}/build/${NAME}

# copy files to servers
for i in `seq 0 $N`; do
    scp txsgen ${NAME}$i:/tmp/
done


# copy to work dir
for i in `seq 0 $N`; do
    echo SERVER ${NAME}$i
    ssh ${NAME}$i "sudo mv /tmp/txsgen* /home/opera/ && sudo chown -R opera:opera /home/opera/txsgen*"
    VALIDATOR=$(ssh ${NAME}$i "sudo bash -c 'ls -1 /home/opera/keystore/UTC*'" | cut -d'-' -f 9)
    echo VALIDATOR=${VALIDATOR}
    ssh ${NAME}$i "cd /home/opera && sudo -u opera ./txsgen importacc 0x${VALIDATOR} ./keystore fakepassword"
    j=$((i+1))
    ssh ${NAME}$i "cd /home/opera/ && sudo -u opera ./txsgen fakeaccs $((10000*j)) 10000 || echo - already done"
done
