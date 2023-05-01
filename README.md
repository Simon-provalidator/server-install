# Configuration
```
GO_VERSION=1.18.10
BRANCH=v9.0.3
NODE_HOME=$HOME/.gaia
NODE_MONIKER=validator
GITURL=https://github.com/cosmos/gaia
NODE_HOME=$HOME/.gaia
CHAIN_NAME=gaia
CHAIN_BINARY=gaiad
CHAIN_ID=cosmoshub-4
STATE_SYNC=false
SNAP_SHOT=true
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/cosmos/cosmos_15059588.tar.lz4
SEEDS=""
PERSISTENT_PEERS="4437ef919ce6f55a4c2672b9808cfb7e2393df37@54.193.193.123:26656"
SYNC_RPC_1=https://cosmos-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/cosmos/genesis.json
EXTERNAL_ADDRESS="{server_ip}:26656"
MEMPOOL_SIZE=500
MINIMUM_GAS_PRICES="0.0001uatom"
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_KEEP_EVERY="2000"
PRUNING_INTERVAL="10"
```

# Start
```
sh {chian_name} setting.sh
```

# Service(Daemon)
```
# Set up Daemon
echo "Creating $CHAIN_BINARY.service..."
sudo rm /etc/systemd/system/$CHAIN_BINARY.service

sudo tee <<EOF >/dev/null /etc/systemd/system/$CHAIN_BINARY.service
[Unit]
Description=$CHAIN_BINARY daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/$CHAIN_BINARY start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable $CHAIN_BINARY.service
sudo systemctl start $CHAIN_BINARY.service
sudo systemctl restart systemd-journald
```

# Service(Cosmovisor)
```
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
```
