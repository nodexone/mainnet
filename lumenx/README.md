<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/cosmos/chain-registry/master/lumenx/images/lumen.png">
</p>

# LumenX Mainnet | Chain ID : LumenX

### Community Documentation:
>- [Validator setup instructions](https://github.com/nodexcapital/mainnet/tree/main/lumenx)

### Explorer:
>-  https://explorer.nodexcapital.com/lumenx/

### Automatic Installer (Must Using Ubuntu 22 Version!)
You can setup your Arkhadian fullnode in few minutes by using automated script below
```
wget -O lumenx.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/lumenx/lumenx.sh && chmod +x lumenx.sh && ./lumenx.sh
```
### Public Endpoint

>- API : https://rest.lumenx-m.nodexcapital.com
>- RPC : https://rpc.lumenx-m.nodexcapital.com
>- gRPC : https://grpc.lumenx-m.nodexcapital.com

### Snapshot (Update every 5 hours)
```
Coming Soon
```

### State Sync
```
sudo systemctl stop lumenxd
cp $HOME/.lumenx/data/priv_validator_state.json $HOME/.lumenx/priv_validator_state.json.backup
lumenxd tendermint unsafe-reset-all --home $HOME/.lumenx

STATE_SYNC_RPC=https://rpc.lumenx-m.nodexcapital.com:443
STATE_SYNC_PEER="bc22063df30a0644df742cdb2764b1004df6e3e3@node1.lumenex.io:26656,9cd5f77ac27254891f64801470b0c3432188c62c@node2.lumenex.io:26656,78669849476c8b728abe178475c6f016edf175cf@node3.lumenex.io:26656,48444a4bacc0cafa049d777152473769ab17c0c3@node4.lumenex.io:26656"
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.lumenx/config/config.toml

mv $HOME/.lumenx/priv_validator_state.json.backup $HOME/.lumenx/data/priv_validator_state.json

sudo systemctl start lumenxd && sudo journalctl -u lumenxd -f --no-hostname -o cat
```

### Live Peers
```
PEERS="bc22063df30a0644df742cdb2764b1004df6e3e3@node1.lumenex.io:26656,9cd5f77ac27254891f64801470b0c3432188c62c@node2.lumenex.io:26656,78669849476c8b728abe178475c6f016edf175cf@node3.lumenex.io:26656,48444a4bacc0cafa049d777152473769ab17c0c3@node4.lumenex.io:26656,3d99b79129adeebd237d4153cbba6a749e0ce489@node1.olivestory.co.kr:26656,8246854d88bbba7acec7b4d86c9b418c90816f1f@rpc.lumenx.indonode.net:24656,2c341d570e537683d23102e64e7b73f4bbaef829@65.21.201.244:26766,1d94c81f6b25a51be173d22523f6267113bfcbec@45.134.226.70:26656,39d8e366837505e3a31948d761cc08ac8ed4a44b@188.165.232.199:26666,9a49635f0ecb7ba93fc9eba952cbe58767557010@185.215.180.70:26656,e91a86a4bec23993f584f346208e7b47285eb632@65.21.226.230:27656,3b584334f64ab60f92388ea22bc870dcacf4c157@157.90.179.182:56656,43c4eb952a35df720f2cb4b86a73b43f682d6cb1@37.187.149.93:26696,3c7c6c284806053c21b0e0dbfd3ca59797eab1d7@65.108.7.44:51656,e3989262b8dff3596f3b1d5e44372e9326362552@192.99.4.66:26666,b9aee01d4a878d0cf6beff20cabc9d4659cdd441@65.108.44.100:27656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lumenx/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/lumenx/addrbook.json > $HOME/.lumenx/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/lumenx/genesis.json > $HOME/.lumenx/config/genesis.json
```