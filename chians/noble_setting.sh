#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v2.0.0
NODE_HOME=$HOME/.noble
NODE_MONIKER=validator
GITURL=https://github.com/strangelove-ventures/noble
CHAIN_NAME=noble
CHAIN_BINARY=nobled
CHAIN_ID=noble-1
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/noble/noble_642691.tar.lz4
SEEDS=""
PERSISTENT_PEERS="f0496ab244c4bc607948934fb261bf5ca124377d@34.168.216.136:26656, cca1c141e0bc7c4c0e8570e76278227547199f34@34.82.228.108:26656, bac93149f2d2f8cdebcae6f7ede003c6d55e9bc5@35.185.245.19:26656, 1336c1158cb71e6830f09c4858b16f3c7c7fdf7f@155.55.88.0:26656, f94a10d645910fa1d20c570217d53e9786d33e4b@10.129.0.8:26656, 46e4d2e65ad5861b9212ec5e15937311b1297ead@0.0.0.0:26656, 7c23071f33d2c4ec490ba8b8eef0fdd9630cab33@192.168.9.195:26656, b9b25bb26fa619ef291ab9b6afbd1deb7bad8c02@135.181.139.232:26656, 37988e2e3cbb96af89c77bd890f56c8558e93b27@172.31.14.121:26656, c23fe2dfd8b48bcb3a4c83e0cf5fe52c8c612aab@65.109.31.114:26656, e0e05a26d9800949594af5165c59d4d8dcfed8a5@192.168.0.102:26656, 2abc089a132bdcf6872cbabedcea730f5ef6ea17@0.0.0.0:26656, aed06b5e0d7cd4983564a60e119af47aff1033ea@211.219.19.69:26656, f1d4be49b5afe0970ea56af680da313b859fcfa2@172.16.6.178:26656, 19ed568f900446104ef9ae73959a1fd481344eea@192.168.1.22:26656, 9ff55b8f0b8c8739e9e7cbc619613e20ea9728cf@192.168.221.142:26656, fb9ca8ccb65d0cb69c966cdfd6fae7c6a5377f3f@35.230.125.14:26656, 6dab1f44ec01bd11dbde6bb44d56fd057297463b@0.0.0.0:26656, 9ea19d5f2b3df18817cd52d2c765539997cec577@66.94.98.139:26656, 48055ab0685253ac2cd17494e546b41265acd7b6@143.42.187.68:26656"
SYNC_RPC_1=https://noble-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/noble/genesis.json
MINIMUM_GAS_PRICES="0.0uusdc"
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
Restart=on-failure
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