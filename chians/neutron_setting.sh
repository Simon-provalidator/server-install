#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v1.0.3
NODE_HOME=$HOME/.neutrond
NODE_MONIKER=validator
GITURL=https://github.com/neutron-org/neutron
CHAIN_NAME=neutron
CHAIN_BINARY=neutrond
CHAIN_ID=neutron-1
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/neutron/neutron_1430773.tar.lz4
SEEDS="24f609fb5946ca3a979f40b7f54132c00104433e@p2p-erheim.neutron-1.neutron.org:26656,20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:19156,b1c6fa570a184c56d0d736d260b8065d887e717c@p2p-kralum.neutron-1.neutron.org:26656"
PERSISTENT_PEERS="e5d2743d9a3de514e4f7b9461bf3f0c1500c58d9@neutron.peer.stakewith.us:39956,982f968cd6ac567fdddf2170f7da9725ba21693d@51.210.209.49:15600,8e2af33b3fc9fee81dda7d351a65d93e8ac97409@65.108.71.163:2480,b119a600d082963d27a9ba9cd762c7c83f00e7d1@81.196.190.108:10083,9cede4e9f58fc3dfc80ad643c0e1f1cbab26b8ba@138.201.135.251:26656,578120cd8bcbd228c54d34e66f6e9347e883440b@15.235.54.38:26661,a16ee5d0f081e3a8bfd0c629b70133e56a1ee3ac@15.235.114.84:24656,6e9138e7ca3bbb5e92c74641949e44f51afe7e80@143.42.183.253:26656"
SYNC_RPC_1=https://neutron-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/neutron/genesis.json
MINIMUM_GAS_PRICES="0.5untrn,0.022ibc/C4CFF46FD6DE35CA4CF4CE031E643C8FDC9BA4B99AE598E9B0ED98FE3A2319F9,0.25ibc/F082B65C88E4B6D5EF1DB243CDA1D331D002759E938A0F5CD3FFDC5D53B3E349"
CHECK=1

# Basic Installation
echo "Installing Basic..."
sudo apt-get update  
sudo apt-get upgrade -y
sudo apt-get install build-essential make jq net-tools gcc gzip sysstat htop chrony manpages-dev -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"
sudo apt update
sudo apt install snapd cargo -y
sudo snap install lz4
curl https://get.ignite.com/cli! | bash

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
fi

# hermes
cd go/src/github.com
git clone https://github.com/informalsystems/ibc-rs.git hermes
cd hermes
git checkout v1.0.0
cargo install ibc-relayer-cli --bin hermes --locked

# Hermes setup
mkdir -p $HOME/.hermes
mkdir -p $HOME/.hermes/keys
cp ~/.cargo/bin/hermes ~/go/bin/hermes
wget https://github.com/neutron-org/neutron/blob/49c33ff43122cb12ee20e98493e0e2439a94f928/network/hermes/config.toml
mv config.toml $HOME/.hermes/config.toml

# hermes setvice
sudo tee /etc/systemd/system/hermesd.service > /dev/null << EOF

[Unit]
Description=hermes Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which hermes) start
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF