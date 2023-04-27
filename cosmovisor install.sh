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
sudo touch /etc/systemd/system/$SERVICE_NAME.service

echo "[Unit]"                                                                        | sudo tee /etc/systemd/system/$SERVICE_NAME.service
echo "Description=Cosmovisor service"                                                | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "After=network-online.target"                                                   | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo ""                                                                              | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "[Service]"                                                                     | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "User=$USER"                                                                    | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "ExecStart=$HOME/go/bin/cosmovisor run start --x-crisis-skip-assert-invariants" | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Restart=always"                                                                | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "RestartSec=3"                                                                  | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "LimitNOFILE=50000"                                                             | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Environment='DAEMON_NAME=$CHAIN_BINARY'"                                       | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Environment='DAEMON_HOME=$NODE_HOME'"                                          | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Environment='DAEMON_ALLOW_DOWNLOAD_BINARIES=true'"                             | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Environment='DAEMON_RESTART_AFTER_UPGRADE=true'"                               | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "Environment='DAEMON_LOG_BUFFER_SIZE=512'"                                      | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo ""                                                                              | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "[Install]"                                                                     | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a
echo "WantedBy=multi-user.target"                                                    | sudo tee /etc/systemd/system/$SERVICE_NAME.service -a

# Start service
sudo systemctl daemon-reload

# Enable and start the service after the genesis that includes the CCV state is in place
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service
sudo systemctl restart systemd-journald