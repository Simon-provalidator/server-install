#!/bin/bash

# Node-home

# Configuration
NODE_HOME=$HOME/.$1
PROXY_APP="tcp://127.0.0.1:10160"
RPC_LADDR=10161
PPROF_LADDR="localhost:10162"
P2P_LADDR=tcp://0.0.0.0:10163
PROMETHEUS_LISTEN_ADDR=":10164"
API_ADDRESS="10165"
ROSETTA_ADDRESS="10166"
GRPC_ADDRESS="10167"
GRPC_WEB_ADDRESS="10168"
KEYRING_BACKEND="file"
KEYRING_DIR="/root/.$1"
NODE="tcp://localhost:10161"

# Config.toml set up
sed -i -e "/proxy_app =/ s^= .*^= \"$PROXY_APP\"^" $NODE_HOME/config/config.toml
sed -i -e "\s \26657\"$RPC_LADDR\"^" $NODE_HOME/config/config.toml
sed -i -e "/pprof_laddr =/ s^= .*^= \"$PPROF_LADDR\"^" $NODE_HOME/config/config.toml
sed -i -e "\s \26656\"$P2P_LADDR\"^" $NODE_HOME/config/config.toml
sed -i -e "/prometheus_listen_addr =/ s^= .*^= \"$PROMETHEUS_LISTEN_ADDR\"^" $NODE_HOME/config/config.toml

# App.toml set up
sed -i -e "\s \1317\"$API_ADDRESS\"^" $NODE_HOME/config/app.toml
sed -i -e "\s \8080\"$ROSETTA_ADDRESS\"^" $NODE_HOME/config/app.toml
sed -i -e "\s \9090\"$GRPC_ADDRESS\"^" $NODE_HOME/config/app.toml
sed -i -e "\s \9091\"$GRPC_WEB_ADDRESS\"^" $NODE_HOME/config/app.toml

# Client.toml set up
sed -i -e "/keyring-backend =/ s^= .*^= \"$KEYRING_BACKEND\"^" $NODE_HOME/config/client.toml
sed -i "/keyring-backend =/ s^= .*^= \"$KEYRING_DIR\"^" $NODE_HOME/config/client.toml
sed -i -e "/node =/ s^= .*^= \"$NODE\"^" $NODE_HOME/config/client.toml