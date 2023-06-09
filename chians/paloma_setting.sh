#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v0.11.7
NODE_HOME=$HOME/.paloma
NODE_MONIKER=validator
GITURL=https://github.com/palomachain/paloma
CHAIN_NAME=paloma
CHAIN_BINARY=palomad
CHAIN_ID=messenger
SNAP_SHOT_URL=https://snapshots1.nodejumper.io/paloma/messenger_2023-05-09.tar.lz4
SEEDS=""
PERSISTENT_PEERS="8ed8cddfac504d986a2c6545def0e57b2c6aa5db@paloma.nodejumper.io:38656,874ccf9df2e4c678a18a1fb45a1d3bb703f87fa0@65.109.172.249:26656,6ee0ed8ddb1eaaf095686962d71fddb1383b5199@65.21.138.123:26656,ab6875bd52d6493f39612eb5dff57ced1e3a5ad6@95.217.229.18:10656,9581fadb9a32f2af89d575bb0f2661b9bb216d41@46.4.23.108:26656,b244dfc19293103040d4bdad359534d0990a9070@45.140.185.181:26656,810bea15ec11d510dd33170851ee2ab74c48b6de@81.0.221.57:26656,741bdc1ffdd93b7de09d8417bc0ada0d2285affa@65.109.57.67:27656,16f0d09580054101394ea08bbb48b1ad5bb91a27@95.214.52.144:10656,e4b7cdd48c39c355e9a3480f4f4d5afab8fb0e08@46.0.203.78:26637,53f37ac93aec70dea3abc40108f42a00877b4665@64.227.142.91:26656,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@65.109.88.38:10656,b92c94f00b46500a5ff8920acd438c0873c2f9da@50.116.13.101:26656,317141e329bc214a76ba92201f6818574ebe5323@135.181.114.98:36656,99c890c97afc8abfdfeff662d539af5c504a0baf@88.99.67.234:26656,41a47bae18f81c1f626e4b238221b77e274424d7@45.33.65.223:26656"
SYNC_RPC_1=https://paloma.nodejumper.io:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://raw.githubusercontent.com/palomachain/mainnet/master/messenger/genesis.json
MINIMUM_GAS_PRICES="0.0001ugrain"
CHECK=1

# Basic Installation
echo "Installing Basic..."
sudo apt-get update  
sudo apt-get upgrade -y
sudo apt-get install build-essential make jq net-tools gcc gzip sysstat htop chrony manpages-dev -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"
sudo apt update
sudo apt install snapd -y
sudo snap install lz4

# Install nodejs
echo "Installing node.js..."
curl https://deb.nodesource.com/setup_20.x | sudo bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install nodejs=20.* yarn build-essential jq -y

# Install go $GO_VERSION
echo "Installing go..."
rm go*linux-amd64.tar.gz
wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
EOF
source $HOME/.profile
mkdir -p ~/go/bin | mkdir -p ~/go/src/github.com | mkdir -p ~/go/pkg

# Install $CHAIN_BINARY binary
echo "Installing $CHAIN_NAME..."
cd $HOME
cd ~/go/src/github.com
git clone $GITURL
cd $CHAIN_NAME
git checkout $BRANCH
make install

# Initialize home directory
echo "Initializing $NODE_HOME..."
rm -rf $NODE_HOME
$CHAIN_BINARY init $NODE_MONIKER --chain-id $CHAIN_ID
sed -i -e "/seeds =/ s^= .*^= \"$SEEDS\"^" $NODE_HOME/config/config.toml
sed -i -e "/persistent_peers =/ s^= .*^= \"$PERSISTENT_PEERS\"^" $NODE_HOME/config/config.toml
sed -i -e "/external_address =/ s^= .*^= \"$EXTERNAL_ADDRESS\"^" $NODE_HOME/config/config.toml
sed -i -e "/^size =/ s^= .*^= $MEMPOOL_SIZE^" $NODE_HOME/config/config.toml
sed -i -e "/minimum-gas-prices =/ s^= .*^= \"$MINIMUM_GAS_PRICES\"^" $NODE_HOME/config/app.toml
sed -i -e "/pruning =/ s^= .*^= \"$PRUNING\"^" $NODE_HOME/config/app.toml
sed -i -e "/pruning-keep-recent =/ s^= .*^= \"$PRUNING_KEEP_RECENT\"^" $NODE_HOME/config/app.toml
sed -i -e "/pruning-interval =/ s^= .*^= \"$PRUNING_INTERVAL\"^" $NODE_HOME/config/app.toml
sed -i -e "/chain-id =/ s^= .*^= \"$CHAIN_ID\"^" $NODE_HOME/config/client.toml

# Replace genesis file: only after the spawn time is reached
echo "Replacing genesis file..."
wget -O genesis.json $GENESIS_URL --inet4-only
mv genesis.json $NODE_HOME/config/genesis.json

if $STATE_SYNC ; then
    echo "Configuring state sync..."
    CURRENT_BLOCK=$(curl -s $SYNC_RPC_1/block | jq -r '.result.block.header.height')
    TRUST_HEIGHT=$[$CURRENT_BLOCK-1000]
    TRUST_BLOCK=$(curl -s $SYNC_RPC_1/block\?height\=$TRUST_HEIGHT)
    TRUST_HASH=$(echo $TRUST_BLOCK | jq -r '.result.block_id.hash')
    sed -i -e '/enable =/ s/= .*/= true/' $NODE_HOME/config/config.toml
    sed -i -e "/trust_height =/ s/= .*/= $TRUST_HEIGHT/" $NODE_HOME/config/config.toml
    sed -i -e "/trust_hash =/ s/= .*/= \"$TRUST_HASH\"/" $NODE_HOME/config/config.toml
    sed -i -e "/rpc_servers =/ s^= .*^= \"$SYNC_RPC_SERVERS\"^" $NODE_HOME/config/config.toml
else
    echo "Skipping state sync..."
fi

if $SNAP_SHOT ; then
    echo "Setting snap shot..."
    wget -O snap_shot.tar.lz4 $SNAP_SHOT_URL
    lz4 -c -d snap_shot.tar.lz4  | tar -x -C $NODE_HOME
    rm -v snap_shot.tar.lz4
else
    echo "Skipping snap shot..."
fi

echo "Cosmovisor Install?"
echo "1. Yes"
echo "2. No"

read i

if [ {$i} == {$CHECK} ]; then

# Set up cosmovisor
SERVICE_NAME=cosmovisor
echo "Setting up cosmovisor..."
mkdir -p $NODE_HOME/cosmovisor/genesis/bin
mkdir -p $NODE_HOME/cosmovisor/upgrades
cp $(which $CHAIN_BINARY) $NODE_HOME/cosmovisor/genesis/bin

echo "Installing cosmovisor..."
export BINARY=$NODE_HOME/cosmovisor/genesis/bin/$CHAIN_BINARY
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.3.0

echo "Creating $SERVICE_NAME.service..."
sudo rm /etc/systemd/system/$SERVICE_NAME.service
sudo tee <<EOF >/dev/null /etc/systemd/system/$SERVICE_NAME.service

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
Environment='DAEMON_ALLOW_DOWNLOAD_BINARIES=false'
Environment='DAEMON_RESTART_AFTER_UPGRADE=true'
Environment='DAEMON_LOG_BUFFER_SIZE=512'
Environment='UNSAFE_SKIP_BACKUP=true'

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload

# Enable and start
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service
sudo systemctl restart systemd-journald

else
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
fi

# Pigeon setup
wget -O - https://github.com/palomachain/pigeon/releases/download/v0.11.5/pigeon_Linux_x86_64.tar.gz | tar -C $HOME/go/bin -xvzf - pigeon
chmod +x $HOME/go/bin/pigeon
mkdir $HOME/.pigeon

# Pigeon service
cat <<EOT >/etc/systemd/system/pigeond.service
[Unit]
Description=Pigeon daemon
After=network-online.target
ConditionPathExists=$HOME/go/bin/pigeon

[Service]
Type=simple
Restart=always
RestartSec=5
User=${USER}
WorkingDirectory=~
EnvironmentFile=${HOME}/.pigeon/env.sh
ExecStart=$HOME/go/bin/pigeon start
ExecReload=

[Install]
WantedBy=multi-user.target
EOT