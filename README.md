# Configuration
You need to modify it and use it. {server_ip}, {snapshot_url}
```
config.sh

# Configuration
GO_VERSION=1.18.10
STATE_SYNC=false
SNAP_SHOT=true
EXTERNAL_ADDRESS="{server_ip}:26656"
MEMPOOL_SIZE=500
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_KEEP_EVERY="2000"
PRUNING_INTERVAL="10"

cosmos_seting.sh
SNAP_SHOT_URL={snapshot_url}
```

# Start
```
bash setting.sh
What network you going to interact:
1. CosmosHub
2. Juno
3. Sifchian
4. Evmos
1
Cosmovisor Install?
1. Yes
2. No
1
```
