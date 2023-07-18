#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v0.5.0
NODE_HOME=$HOME/.babylond
NODE_MONIKER=validator
GITURL=https://github.com/babylonchain/babylon
CHAIN_NAME=babylon
CHAIN_BINARY=babylond
CHAIN_ID=bbn-test1
SNAP_SHOT_URL=https://snapshots.polkachu.com/testnet-snapshots/babylon/babylon_639037.tar.lz4
SEEDS="03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:20656"
PERSISTENT_PEERS="4e38cd41181ad5c5033553b679cba3b4cdb5d1c4@65.108.101.124:14656,a8051774e809d8dc14673bb245abc0fc48a3f684@5.9.122.49:14656,87b3d99aaa2134815fd8ce389011407c6d4ddd8f@42.117.66.62:26656,e98cc273ce0ec58d278807179001fcb386ba550b@141.95.97.28:15556,4b72eddd41f865bfa09a75e7f50dcdf43f2f1693@65.108.13.110:26656,ae5b89a8f1934e45ad3698671005a56623f04111@213.239.207.165:29056,c07d98676bfbf8fa28bbca82532a3a4841930500@185.246.86.63:26666,322113757332da320c929bc444eb89c326c7b1d7@219.100.163.45:46656,b068b6464f706e53c8cdbbbdf964477f9a589c6a@65.108.237.233:31656,49cdcda3061fd1b467c6a5c29f56b85653e807f2@94.131.106.139:26656,57561b59f971773e19dbb0635203d6909c3e3dbe@27.72.126.82:26656,0100cbf147f512b81cd01268463bd71ab3e55138@65.109.85.226:4310,7cf424ff2939501d9ab9296889e5ab66c826527a@65.109.85.221:4310,c4c473143dc8b1a26cf62074572e501b6444aed8@193.203.15.130:26656,b2c3a12aba7cbfa34cdb45a5b6f133fb7f251817@65.109.85.225:4310,c2bc08c7b0292f7072b1530ffc03ebf69563f518@95.216.39.183:27656,3505887a9672a4c0babea20167d608a9584ba03b@172.104.159.69:55706,535e68a8e40f0c1d53d73f3bdc47c365cc32924c@176.37.119.156:26664,0e64bf0adab64d4ef33522441c0ec34d0147e8bd@65.108.200.60:25656,aa3ffeb7fa6c82c85104038da52f18689ed8a1e5@65.109.63.110:14656,aff3bffaf6e8489a2b2738d09686d596048799dd@23.88.69.101:14656,2082756ec14fb59d54893b2ca83f1846996b0989@65.108.66.34:29056,b53302c8887d4bd57799992592a2280987d3f213@95.217.144.107:20656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.135:27116,cd9d96f554e7298a8d1f1a94489f7a51520f01ff@142.132.152.46:47656,03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656"
SYNC_RPC_1=https://babylon-testnet-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/testnet-genesis/babylon/genesis.json
MINIMUM_GAS_PRICES="0.0bbn"
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
wget $GENESIS_URL
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