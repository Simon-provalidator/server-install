#!/bin/bash
# Set up a service to join the  chain.

source ./config/config.sh

# Configuration
BRANCH=v5.0.0
NODE_HOME=$HOME/.cantod
NODE_MONIKER=node
GITURL=https://github.com/Canto-Network/Canto
CHAIN_NAME=Canto
CHAIN_BINARY=cantod
CHAIN_ID=canto_7700-1
SNAP_SHOT_URL=https://snapshots.polkachu.com/snapshots/canto/canto_5072244.tar.lz4
SEEDS=""
PERSISTENT_PEERS="744294d2ecf5ddf14065be6d325e68dcbdf0c646@66.172.36.136:51656,f9fc759eb2fa4eb2159825cae149ba1065efa236@66.172.36.134:51656,81f89cfa6dd6ec4cb2ee297e67dd4613657c4194@88.198.32.17:30656,bea21c6cc721726a486dbd7f14c5e81ee12f6eaa@35.83.23.119:26656,f9f8f88dfde1bacca2f152089bb20c600dbb9d04@43.204.152.200:26656,510e68d0b0ccb903663637547bf641961c4c9987@185.229.119.216:26656,2d7826e04685c4afb7baf6a045a3098c1306e1cc@5.9.108.156:35095,8cb9419ede1d830e78b4dd1318bdbd4e6be000d7@144.76.27.79:36656,f886849e7f563c5c3e4f5a666be76a2184b246ef@85.10.203.235:26676,76789b7d030697abbb9b0f1bed103abb4a66c029@138.201.85.176:26676,a441b9fec8006f28fb2add0517fa823b886834d6@5.79.79.80:35095,1d3ab5cc05452e29d8dafb4f96fcf3841c485287@51.210.223.185:35095,9723b0dac535d9e5c28e62413ddda54386ff8955@138.201.249.155:26656,bc091cdde82ad9a27a6b2b279b280aab1041d9bf@13.53.40.117:26656,8b2ac4899b5a0b6e289850bde707f45421d1e9a4@213.239.207.175:30656,43393ba9763a9b1b95785330c5059811e5ed7f91@95.217.122.80:17656,685c48cbc2ba54e20f49645d48b0878d6944d8e4@65.109.94.221:32656,978a3730fc791492c009ff380d8e8bb25997da1b@65.109.65.210:29656,b8cc93a20982f6e7dd0201757c642d2ddc76eee9@148.251.53.202:26656,484e252942ffcc0c6e31278ac0f47a3ca1317aef@142.132.238.165:26656,2ba20f6ff6be62590447ec964bb51bd67460f492@5.9.107.174:36656,fa20e4f196268858f56213c77bfa5481aeab4547@66.206.15.130:26656,61c8c3dce43e7221a5dab1a3c86366f34d2edddd@213.239.215.77:26656,876a17aa48201ec9b8937d81e28b44bfcb4d318c@15.235.115.149:10004,34828d479df21e65068b6aa7b885cfaa6acb4118@5.75.140.177:26656,f724d16c43147bad59a036f243aa79c6f4455d2d@23.88.69.167:26858,cdad27c5be53788cbf42dd1336adeabc253b6e52@38.242.251.238:26656,82956d94714ded8fd785acb498a0aeb7aafad7ff@85.17.6.142:26656,5401995b201605a03d9e1fd0460cbef49218bbf5@65.108.126.46:32656,6ed040a6d393738c1bbeebd200c2e2f660614907@135.181.222.179:28656,bedcf918f53967cd37a0d03e67997d1b40c6c152@5.161.113.61:26656,8f21e61a2a81c96e5b761b256cd5c9d13a325281@86.48.2.82:26656,f74639c33b7647b0462e634974147c20505747a6@213.239.216.252:23656,6085683689776e7103ea5ea87c0f74d9a69e21a2@167.235.200.184:26656,e6d62aa5215719eb1b7434e19bca4e7f62923ef4@65.108.106.172:58656,0da4f6242164ea9ce74bf6e8602c32d408140693@95.217.77.23:27656,c9e39b78c37b1bd360676d1e68f40a1f6c36d528@109.236.86.96:36656,69c21a89c74d08cb4a3c463dc813fe279fe4f080@51.79.160.214:26656,4fb5a871a1f263752da75e323e2ed73ed315a17f@95.214.52.138:26666,4a6ff3311b13fea6db8e6f28bb4a1527df3371bf@65.109.162.26:26656,54316791649b65af344432bf4bd31f46df0cb79c@51.195.234.49:27756,7be1b2faf6a308b6d445edb40f9598195f2455d9@148.251.41.20:26656,ab88f189db7825f376050a034d8bf0028442cfc3@34.89.161.101:26656,5ce67581ef51b30c70212a870f2e5ede27c31929@65.109.20.109:26656,ebd18bdf64ac9b8d0e38ab8706fcf9ee1d54e70a@95.217.35.186:60656,6e7e9341fba194988d448393b2d77464107385c5@65.108.199.222:22496,d36a57b72f12cc648aeb0b417002a2dc390c76c2@89.58.19.40:26656,a0a165866cf5408ed26459ff91e3968807fb13dd@152.228.215.7:26656,439d6746ec2ddeb03a4328e9ab1d0806e5d46ccd@34.252.21.196:26656,8e4d886e7c333e73cdf1f0271b05511a1866d515@65.109.49.163:56656,ec623695c6dfaa265d9d7f5e3b058c51bca63f4f@65.108.124.219:27656,9188d4b9b9e1a7e86ac6a0e6bee343e4c5f6fa25@114.32.170.200:26656,325eaed0931fc7d743c6ee9b124bca334ff8dc2c@65.109.92.241:21216,a93a2839d71a1a705c912163fcf3280e674c5647@204.93.241.110:27650,95296d725bf8d869147e33d236c3cb6102601529@95.217.192.230:46656,6f811ea67bcf1275ef55e0535630af783f767344@95.214.53.178:26656,c7e5de7911802a8c7f80c046ad93152476898d56@202.61.194.254:36656,1797a6e3a45ea538dc669e296e5f76a3b510d101@65.109.29.150:26656,f77128aa0e32853a5938642521990a69b4ae95e7@144.76.195.147:26656,3b25a50bf0fd8f5e776d2e17f4a0d75883bca7fb@65.108.227.42:26656,f15b2375cbfb2b9200096e311b8a1f703e7c2a68@149.102.153.162:26656,81fc7f83e9961790a279a1fbe3e2835cea032d0c@37.252.184.229:26656,43882ebdac4fef48671b35c236122cfcefef413c@63.141.239.202:26656,80e65f207db973bc98d5b02daf5db0607b0a382e@66.172.36.133:51656,26c20d0d4875abfbb9269e5cd57e8f9245ff4c71@65.108.126.35:27656,469a2a16c0f8274ace1a587961f0693f4652f77c@167.172.146.235:26656,74346567ad07541f8163be580c2b6667a1f97fe5@95.214.53.105:36656,0ea8451a880b469be9f94a379dc2b63ea829d16a@208.91.106.29:26656,42e5c9923c06e2100a19814c2fffbbdea641032d@15.235.114.194:10456,7c148e004ec16f7849e148ba56e6a985202105a3@34.207.111.238:26656,6b90bb94063007ff88c14585debd84ababd7d637@65.108.79.198:26766,21fbfac4b643d06ed0edf92e22b2836a1a6e06a2@195.201.123.208:26656,64172382922c636354387436d7e3b494b1abf577@46.10.221.196:26656,4ff352af6db6e68fc6913e82589c4c8dbfc88f6c@35.76.185.2:26656,174f015f606fd1f139447158b81a1824f6352854@65.108.75.107:16656,f3a0c2e660defc476dfe555ab128790422db1cf9@195.201.171.173:27656,855dc3bfa1303bc8de211181918de78f1d9be7c8@67.205.146.202:26656,cf5dc9c8eb848ce339e4ce7af7db50a46799edef@146.190.136.204:26656"
SYNC_RPC_1=https://canto-rpc.polkachu.com:443
SYNC_RPC_SERVERS="$SYNC_RPC_1,$SYNC_RPC_1"
GENESIS_URL=https://snapshots.polkachu.com/genesis/canto/genesis.json
MINIMUM_GAS_PRICES="0.0001acanto"
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