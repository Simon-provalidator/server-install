#!/bin/sh
# Set up a service to join the  chain.

NODE_HOME=$HOME/.nomic-stakenet-3
CHAIN_BINARY=nomic
CHAIN_SIGNER=nomic-signer
CHAIN_RELAYER=nomic-relayer
NODE_MONIKER=node
SEEDS="238120dfe716082754048057c1fdc3d6f09609b5@161.35.51.124:26656,a67d7a4d90f84d5c67bfc196aac68441ba9484a6@167.99.119.196:26659"
EXTERNAL_ADDRESS="5.78.46.71:26656"

# nomic currently requires rust nightly
rustup default nightly

# install rustup if you haven't already
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install required dependencies (ubuntu)
sudo apt install build-essential libssl-dev pkg-config clang

# or for systems running fedora
sudo dnf install clang openssl-devel && sudo dnf group install "C Development Tools and Libraries"

# clone
git clone https://github.com/nomic-io/nomic.git nomic && cd nomic
git checkout develop
git pull
cargo install --locked --path .

# Initialize and configure your node
echo "Initialize your data directory"
$CHAIN_BINARY init

sed -i -e "/moniker =/ s^= .*^= \"$NODE_MONIKER\"^" $NODE_HOME/tendermint/config/config.toml
sed -i -e "/seeds =/ s^= .*^= \"$SEEDS\"^" $NODE_HOME/tendermint/config/config.toml
sed -i -e "/external_address =/ s^= .*^= \"$EXTERNAL_ADDRESS\"^" $NODE_HOME/tendermint/config/config.toml

# Set up Daemon
echo "Creating $CHAIN_BINARY.service..."
sudo rm /etc/systemd/system/$CHAIN_BINARY.service

sudo tee <<EOF >/dev/null /etc/systemd/system/$CHAIN_BINARY.service
[Unit]
Description=Nomic daemon
After=network-online.target

[Service]
User=root
#ExecStart=/root/.cargo/bin/nomic start --state-sync
ExecStart=/root/.cargo/bin/nomic start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

echo "Creating $CHAIN_SIGNER.service..."
sudo rm /etc/systemd/system/$CHAIN_SIGNER.service

sudo tee <<EOF >/dev/null /etc/systemd/system/$CHAIN_SIGNER.service
[Unit]
Description=Nomic signer daemon
After=network-online.target

[Service]
User=root
ExecStart=/root/.cargo/bin/nomic signer
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

echo "Creating $CHAIN_RELAYER.service..."
sudo rm /etc/systemd/system/$CHAIN_RELAYER.service

sudo tee <<EOF >/dev/null /etc/systemd/system/$CHAIN_RELAYER.service
[Unit]
Description=Nomic Relayer
After=network-online.target nomic.service nomic-signer.service bitcoind.service

[Service]
User=root
ExecStart=/root/.cargo/bin/nomic relayer --rpc-port=18332 --rpc-user=satoshi --rpc-pass=nakamoto
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Run your node
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable $CHAIN_BINARY.service
sudo systemctl enable $CHAIN_SIGNER.service
sudo systemctl enable $CHAIN_RELAYER.service
sudo systemctl start $CHAIN_BINARY.service
sudo systemctl start $CHAIN_SIGNER.service
sudo systemctl start $CHAIN_RELAYER.service