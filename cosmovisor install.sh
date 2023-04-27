#!/bin/bash

# Binary-name Node-home

# Configuration
CHAIN_BINARY=$1
NODE_HOME=$HOME/.$2
SERVICE_NAME=cosmovisor

# Set up cosmovisor
echo "Setting up cosmovisor..."
mkdir -p $NODE_HOME/cosmovisor/genesis/bin
mkdir -p $NODE_HOME/cosmovisor/upgrades
cp $(which $CHAIN_BINARY) $NODE_HOME/cosmovisor/genesis/bin

echo "Installing cosmovisor..."
export BINARY=$NODE_HOME/cosmovisor/genesis/bin/$CHAIN_BINARY
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.3.0

echo "Creating $SERVICE_NAME.service..."
sudo rm /etc/systemd/system/$SERVICE_NAME.service
sudo tee <<EOF >/dev/null /etc/systemd/system/$CHAIN_BINARY.service

[Unit]
Description=Cosmovisor service
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/cosmovisor run start --x-crisis-skip-assert-invariants
Restart=always
RestartSec=10
LimitNOFILE=50000
Environment='DAEMON_NAME=$CHAIN_BINARY'
Environment='DAEMON_HOME=$NODE_HOME'
Environment='DAEMON_ALLOW_DOWNLOAD_BINARIES=true'
Environment='DAEMON_RESTART_AFTER_UPGRADE=true'
Environment='DAEMON_LOG_BUFFER_SIZE=512'

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload

# Enable and start the service after the genesis that includes the CCV state is in place
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service
sudo systemctl restart systemd-journald