#!/bin/bash

HOST=$1

export $(cat ./.env | awk '!/^#/' | xargs)

echo "install fluentbit daemon to host..."

ssh root@"$HOST" 'wget -qO - https://packages.fluentbit.io/fluentbit.key | sudo apt-key add -'

ssh root@"$HOST" 'add-apt-repository "deb https://packages.fluentbit.io/ubuntu/bionic bionic main" -y'
ssh root@"$HOST" 'apt-get update && apt-get install td-agent-bit -y'

scp ./fluent_bit_${REMOTE_PROVIDER}.conf root@"$HOST":/etc/td-agent-bit/td-agent-bit.conf
scp ./fluent_bit_parsers.conf root@"$HOST":/etc/td-agent-bit/parsers.conf
scp ./fluent_bit.lua root@"$HOST":/etc/td-agent-bit/scripts.lua
scp ./td-agent-bit.service root@"$HOST":/lib/systemd/system/td-agent-bit.service

echo "set fluentbit variables fron env file..."

ssh root@"$HOST" 'sed -i "s|{{LOGGER_FILE}}|'${LOGGER_FILE}'|g" /lib/systemd/system/td-agent-bit.service'
ssh root@"$HOST" 'sed -i "s|{{LOGGER_PREFIX}}|'${LOGGER_PREFIX}'|g" /lib/systemd/system/td-agent-bit.service'
ssh root@"$HOST" 'sed -i "s|{{LOGGER_SERVICE}}|'${LOGGER_SERVICE}'|g" /lib/systemd/system/td-agent-bit.service'
ssh root@"$HOST" 'sed -i "s|{{LOGGER_HOST}}|'${LOGGER_HOST}'|g" /lib/systemd/system/td-agent-bit.service'
ssh root@"$HOST" 'sed -i "s|{{LOGGER_PASSWORD}}|'${LOGGER_PASSWORD}'|g" /lib/systemd/system/td-agent-bit.service'

echo "setup hosts data..."
HOST_IP=$(dig +short ${LOGGER_HOST})
if [ ! -z "${HOST_IP}" ]; then
    ssh root@"$HOST" 'if grep -F "'${LOGGER_HOST}'" /etc/hosts; then echo host '${LOGGER_HOST}' founded; else echo '${HOST_IP}' '${LOGGER_HOST}' >> /etc/hosts; fi'
fi

echo "setup fluentbit service daemon..."

ssh root@"$HOST" 'systemctl daemon-reload'
ssh root@"$HOST" 'systemctl enable td-agent-bit'
ssh root@"$HOST" 'service td-agent-bit restart'
ssh root@"$HOST" 'pm2 install zhaodx/pm2-fluentd'

echo "all done..."
