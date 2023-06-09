#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v15.1.0
NODE_HOME=$HOME/.osmosisd
NODE_MONIKER=node
GITURL=https://github.com/osmosis-labs/osmosis
CHAIN_NAME=osmosis
CHAIN_BINARY=osmosisd
CHAIN_ID=osmosis-1
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/osmosis/osmosis_9468836.tar.lz4
SEEDS="63aba59a7da5197c0fbcdc13e760d7561791dca8@162.55.132.230:2000,f515a8599b40f0e84dfad935ba414674ab11a668@osmosis.blockpane.com:26656"
PERSISTENT_PEERS="3226b67b2bb9da41b633392a785e87e8f6749939@162.55.245.149:12000,f4b811759e55f665180545ad5e1b42573f660861@135.181.181.251:26656,63e4dd6530bf4dc4c2202be256b262a27d661106@146.19.24.108:26656,aa88cb583b8d932cadfcfd40de6594a64200da93@167.235.135.248:26656,f701e7a1c6b6d7d6ed0c77f7605ee31c730c8c5c@51.159.2.22:26656,c124ce0b508e8b9ed1c5b6957f362225659b5343@136.243.248.186:26656,a5edb41ef3ec40d09bc59a62f4337fc572971ab2@89.149.218.47:26656,71eab9bbf4edabb7b0f2d58e409edc7eb2a98a78@54.241.23.96:26656,a50c8dcd0e83032b5e29d5c5beef6e54ddafb508@35.83.253.164:26656,4cccbb26639559c39f44758d246c5ed928f7717f@176.9.19.66:26656,5de15f4453e014003d0364621112a284f8485f1a@65.109.21.76:26656,8a0caf4581f135b1468408ec398d94573da02e8c@198.244.202.140:26656,a559df67d051d54627a3e25584ff18b8ca55a8b0@95.216.46.251:26656,d6228417e917647022d7a6ae2cca8692645801a9@18.117.143.200:26656,e30f205bfe7042fce50b51909b22fb305e748e8f@148.251.13.186:12556,38cee00b10d47bd2bcc4979b3eae18c517a9d98e@5.199.170.109:26656,b54d611ce10b7a4e816fae4e0b87b44f25c7da74@50.242.73.9:26656,a988534ab1e4bc42aad26ea7ec7bdc7d5415a14c@172.111.52.52:32660,ba90bda66b2436e42f07da1659c715aa1e7e98b3@15.235.14.240:26656,63b4a45bb2276fe141e69ce83750a2c53f1ceeda@198.244.202.196:26656,7c67d9031b6ebb4372a77f02e486bd12d2a3b506@204.16.244.149:26656,4a837e3411b0281f00c07706cfea72d3ebc575f1@176.9.38.49:26656,f14b97210391255b5b439ce70cac7ad6a4694cc0@124.57.61.95:26656,89b6c99ecd215cbd7eeac7fe9636295600198621@176.9.158.219:41056,7c5459ea4bbc41aa4d86ffe8126f0651155227c8@85.195.102.127:26656,4d1828a3df5a7c3d05030897eb7c82e6ac79c520@135.181.138.95:12000,4c927f93d430baf31e6d6418e62c56f442f092bc@46.4.28.42:26656,c5358545d951ae666c695903036c1e93578951eb@135.181.176.113:26656,9c1a9d04c2d642dd3297672f734d47d87f236ae4@135.181.129.117:26656,253bc0e57f48cb4f70493e6109b756208e20e8fe@135.181.171.121:26656,08ceabce6dadc0aa5d33dc2058b9eeeff6186116@142.132.248.253:27656,fc590afe489a1b9ca8ff3f2fb396dbc20b1997a4@204.16.244.254:26656,5696d9806c883beb725fb469d90039d921107b5b@116.202.209.186:26656,32e9d4a7413dd5393c8be004bee68dea683be839@65.21.227.95:2004,66d9a8091d39c066841ed99ee9a0cd3472b5ef0d@15.235.53.79:26656,8e72d0b37a9dc16ea58c0da705caa6530badd6ce@138.197.68.193:26656,42745690b41f6a7515c4a87d88efda2e82b55b76@78.46.94.183:26656,913e9db0332df1152e5afe032ab81bdb65e3f91c@110.11.23.44:26656,91050cbd3da659fddd536c1323a695d22c729d34@103.180.28.206:26656,0813f61788331d5fdf66246b50cd417652194c27@23.106.120.19:26656,94a5f37693ba36617029a47d654460d161678af6@128.0.51.4:26656,ac2fbcb5de633d136a942c28c3049e3edbc6e69a@85.239.233.61:2000,31d2c86f7957e2db91297e54c3b0456ea06c2250@173.67.177.115:26656,6356bf6b58b3a8c2015d411b453e1521e511eafd@65.108.242.218:26656,d557fd150f11883e93c23d8fcab19ef343db8096@35.215.38.241:26656,ab761b6eabdb051518b6230df0f48ee34ea48048@45.79.182.189:26656"
SYNC_RPC_1=https://osmosis-rpc.polkachu.com:443:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/osmosis/genesis.json
MINIMUM_GAS_PRICES="0uosmo"
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
sed -i -e "/size =/ s^= .*^= $MEMPOOL_SIZE^" $NODE_HOME/config/config.toml
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
