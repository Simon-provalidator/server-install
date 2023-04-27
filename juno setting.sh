#!/bin/sh
# Set up a service to join the  chain.

# Configuration
GO_VERSION=1.18.10
BRANCH=v14.1.0
NODE_HOME=$HOME/.juno
NODE_MONIKER=node
GITURL=https://github.com/CosmosContracts/juno
CHAIN_NAME=juno
CHAIN_BINARY=junod
CHAIN_ID=juno-1
STATE_SYNC=false
SNAP_SHOT=true
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/juno/juno_8012819.tar.lz4
SEEDS="47ba9e0e413e14a778b0c2139d7e49cf3d3c9c07@141.94.195.104:26656"
PERSISTENT_PEERS="4a91597dfe3ec715bbf6def225066fbb6ad86cfe@207.180.204.112:36656,9db06fae1998a14c79cb13d50152828b9fa049e9@195.201.161.122:26656,bae287c31f9b23642be7c3c71a9420d6361807b1@95.216.101.38:26656,f5cfce229f71997d7f4cc766909427ee76a8b4f3@38.146.3.191:26656,ec41af656b3450050ae27559b66b877373c44861@65.21.122.47:26656,5479526dbdf4f27aa59ddc52be9cf2614049d28e@185.216.178.75:26656,fd1e3f9baf1922f81bfd9754ddbc4269dbf08264@38.146.3.181:26656,e0fbaf1ef89afad23444e67b334bdf78a4b598fd@65.108.71.92:52656,a08f7b76eb274fb453dcb8be8b237ddb90e41638@135.125.180.36:36656,f79ce2fab55e56b408d76ddcbc1c82c1a90e315b@54.74.146.114:26656,39b02285db6a2fe87aad8f17c70e68e037bedbde@185.252.235.216:26758,ed90921d43ede634043d152d7a87e8881fb85e90@65.108.77.106:26709,8228e05a49947039b1ab9f26ac1eac3c96f56031@135.181.223.115:26656,bd0c65e90ea582d45a84bf0c7a46b7eac19b3613@88.99.219.120:52656,962c55015ea99f769a50c78c1cc4edf6bc174ab2@173.212.246.126:26666,51f9e32a76d738c51dfa353917cef10729b6a600@161.97.118.84:26656,c96c8e2b31bda1bde94e14dc4cbd483156d72348@194.146.25.205:26656,edc35b09613096598e20f8508c977806093d7eec@194.61.28.217:26656,abfccd2f0935e07e3c3494f4ca2e6228e5779267@64.5.123.27:26656,256a94965d448b56bd05e01eb4af082f5e65cfc2@222.106.187.14:53706,e0cf28c0a5180dd72d7c444d08bd425723995bf9@13.38.148.24:26656,ae50fb5e1b4d57aeacd15f623825b72fda210b21@159.203.187.173:26656,9c7b6cedc9b063ed4b1ec18cc88a6960493568eb@66.228.33.24:26656"
SYNC_RPC_1=https://juno-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/juno/genesis.json
EXTERNAL_ADDRESS="5.78.46.71:26656"
MEMPOOL_SIZE=500
MINIMUM_GAS_PRICES="0.0025ujuno"
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_KEEP_EVERY="2000"
PRUNING_INTERVAL="10"
SNAPSHOT_INTERVAL=2000

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
wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go*linux-amd64.tar.gz

# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
EOF
. $HOME/.profile
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
sed -i -e "/pruning-keep-every =/ s^= .*^= \"$PRUNING_KEEP_EVERY\"^" $NODE_HOME/config/app.toml
sed -i -e "/pruning-interval =/ s^= .*^= \"$PRUNING_INTERVAL\"^" $NODE_HOME/config/app.toml
sed -i -e "/snapshot-interval =/ s^= .*^= \"$SNAPSHOT_INTERVAL\"^" $NODE_HOME/config/app.toml
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