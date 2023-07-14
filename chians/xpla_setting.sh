#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v1.2.2
NODE_HOME=$HOME/.xpla
NODE_MONIKER=node
GITURL=https://github.com/xpladev/xpla
CHAIN_NAME=xpla
CHAIN_BINARY=xplad
CHAIN_ID=dimension_37-1
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/xpla/xpla_4637983.tar.lz4
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:20156"
PERSISTENT_PEERS="c5fda23b0936d6701040cef7241fd20299f941de@35.212.236.128:26656,2b405c3f35a0d8786a589b40cacddf9d25afe3d5@65.108.45.172:12259,15d365ce8bfaff27ad4260e5db3fba480d334c39@52.28.248.241:26656,f738e659a3b84aac80094ca49eb0ba31378a2af0@136.243.173.167:26656,a541296594260c143da79f02cc89684abc53f19c@34.88.115.72:26656,c6152fb17787df09d40975de0fd9a7b0501d9685@93.115.25.106:25656,931a388b12dad6904989181dbf17bb83a7ed92a5@38.242.192.114:28656,8a90a314f72d80aeee45276b82697fb134304f14@34.123.207.221:26656,0424d36196d0f1a68f4f4df3fb6ac9b224cc3ce5@49.12.121.248:46656,329e31ebb3ea0aee232c89bf86040a05dfb56e94@139.162.182.81:26656,599a159bbde7a409ffbf15b49efb6bb3d8652dd1@34.159.102.11:26656,f895a778bc581529d1348bdac69eed99348fe87f@165.22.228.158:26656,7e30e18fc409d029da11b34b21a41c51a6010ce2@52.73.220.215:26656,a3815847c00797b63dade162648aa07574003968@147.182.146.152:26656,82a38064864dac19cec7f09e3c5eca26d06ba5ff@35.245.222.190:26656,7364858f416c1890c85a83afedf1afecccb9a9de@34.86.128.71:26656,172e30ea9a976cc9a8dd619adefad987f0c1e531@52.16.172.76:26656,d5c5908a5390b2278180ce975d94d4a43da4952b@34.89.191.254:26656,2e700b8829238033e7742ed073681df200b637d3@104.154.228.132:26656,b05b46d681434644e86ac21b837455c1217efbad@34.66.89.137:26656,ca757c6e1144cc8c49813f8e71cd925e86e959c3@94.237.93.61:26656,e6d30a1d191c64ff301c44f9ddd9d0b3d1f9ee7a@35.230.121.77:26656,fa9585ef51316cda0125bb9bed1d35f59d7448b9@104.196.250.63:26656,d397c4ae86e55e4ea4646625f6596116ff9baf70@195.189.96.121:25656,e92a138fd74b94f83325062d737c8a0eedd9b13f@34.142.251.87:26656,6592da1bfd8bea853b89946d4c502586e2712b4e@34.87.100.83:26656,978ac1c601e44c60727f0c57589ae0b79dc87551@34.124.143.200:26656,0af2efd66f18d28801575026e44f1c3a56e31d4d@65.108.8.247:20156,ba0af6e86413dca685bcc79acac13ec6005fbf0b@54.183.210.199:26656,b42c4c48b2dd4eebc8861c5eb00b65eb9201fecc@34.64.188.86:26656,721e392a52e5c0468fe4e4dd9554f353ff2c6d0e@162.19.170.154:26856,88c62eea9c6229c26cd45d1f58cf48bfc1463b31@130.211.121.170:26656,a53731eeb97129cd6e92cc67fdac555935d2b43e@86.111.48.13:26656,d6297cd822147a0983a08798a18be3aa4b636802@172.104.202.72:26656,653740f6298be41cffc984bba7c86833ce506ae0@139.144.66.95:26656,6ad0c1e872358bec113e5fb75a643e2eaac789f5@185.188.42.44:28656,04160f250bbd4659fa55cfae3cc02a175bd63ad3@13.39.28.208:26656,ae3caf87f74a4ad81f60901a280c9a940583e9eb@146.59.81.92:25656,f5d8fbb6a31491c4717e52eb048c52044c7cb516@86.111.48.12:26656,7ef7d16fbc7f695f6e19f421968355fe99c33123@89.149.218.232:26656,3ffed7ab7d05c4b9bd441e667470816b35176e34@5.9.95.18:26656,ad59ff9bd9717de2139b0cb387f5b590881b52a9@213.239.218.210:46656,06c7d35bc30f0f46d66f64ea58adbf87c651c7ee@3.36.6.44:26656,a61ddaed64b2bef97820e25e33e7917bce4f3ebd@89.149.218.139:26656,20efae903a26d25f23a8f159bc5c814bca50a7f8@80.190.129.50:26656,365b46134243e8f912065406c4e5348203a680c6@157.90.232.154:26656,8f933c81993d9522d55359d6b7519507697add38@57.128.144.229:26656,b415fa64631d4370bd274d6a79bca51be4cfbd42@74.118.143.27:26656,d5c9aec6b9526fec242ad7d9d08b4b3300066797@176.103.222.55:26656,82cd8370f17dc7fcca0d577103d4d5014e34156f@34.126.107.138:26656,30e51fb91a85e9758946615bb9f1c0145c8c46b5@15.235.53.91:13856,8c076f89057991d6097cb09944aa666685d74072@192.99.44.79:20156,c0527af78911ef33245cd464a9aa4bb239978a6b@35.167.159.180:26656,864305fb9b5988862decadc077244f99406a8c91@65.21.89.240:26634,ae63f5bb9d41816d8de1647f11c2afe66c97cb1c@157.90.199.94:26634,6a302d1d920d9028e026b5f8604a8f01b8af7f05@37.122.252.18:28656,42bf89e1a6411a6d22ec63bb1289efa928cee212@74.118.143.46:26657,6395e242a65a07d8c2cae10d6f9fabd4794bea30@133.186.198.233:26656,7af3e0e88fc8c06eb8e7bc1be8cec6827c7e7627@37.120.245.64:26656,e8d713c69b5e714c8518f3fe36cb67424597b4ba@74.118.143.111:26656,e7b6016ce5663a69ba71a982072315545eb0d5f6@52.91.250.19:26656,878d5e7f8043f4adbc065cfc80a7fc25b702efcc@35.206.228.130:26656,29aef16552e478310c938e0a76d32d31a6bf5904@13.125.189.187:26656,df725adce5e063d30bc6a234fc90f47320d7028e@13.113.208.183:26656,e74e225de2b814ea2792aef6eb4fef7e0fa1ba37@3.38.183.21:26656,3ee401831a45c64a7cbc60f8f6b963f79cc7b26c@35.72.12.113:26656,5e5d45464a8490f9374a3cb7f71dd10d180eb7f9@35.213.144.17:26656,be4b044b87bceedc629cc1d4c284fc1b13b56d85@18.181.171.210:26656,c33a6238b03509af945e38d44f23700ffafa9275@35.213.140.41:26656,15efa0a83dff372752369cc984492d9ee72f332b@54.81.115.88:26656"
SYNC_RPC_1=https://xpla-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/xpla/genesis.json
MINIMUM_GAS_PRICES="850000000000axpla"
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