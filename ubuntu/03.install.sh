#!/usr/bin/env bash
cd $(dirname $0)
. ./00.params.sh
set -e

N=$((NODES-1))
cd ${SRC}/build/${NAME}


# copy files to servers
for i in `seq 0 $N`; do
#    scp -r ./node$i ${NAME}$i:/tmp/lachesis
#    scp -r ./lachesis ${NAME}$i:/tmp/lachesis
    ssh -T ${NAME}$i << CMD
rm -f /home/lachesis/lachesis/validator.password
sudo cp /home/ubuntu/validator.password /home/lachesis/lachesis/validator.pswd
sudo chown lachesis:lachesis /home/lachesis/lachesis/validator.pswd
CMD
#sudo killall lachesis
#sudo mv /tmp/lachesis /home/lachesis/lachesis
#sudo cp -r /home/ubuntu/.lachesis/* /home/lachesis/lachesis/
#sudo cp /home/ubuntu/config.toml /home/lachesis/lachesis/testnet.toml
#sudo chown -R lachesis:lachesis /home/lachesis/lachesis
#CMD
done

exit 0

# configure and run service
for i in `seq 0 $N`; do
    ssh ${NAME}$i "sudo ln -s /home/lachesis/lachesis/lachesis-node.service /etc/systemd/system/lachesis-node.service && sudo systemctl daemon-reload && sudo systemctl start lachesis-node"
done
