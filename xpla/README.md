<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/xpla.png">
</p>

# Xpla Mainnet | Chain ID : dimension_37-1 | Custom Port : 120

### Community Documentation:
>- [Validator setup instructions](https://polkachu.com/networks/xpla)

### Explorer:
>-  https://explorer.nodexcapital.com/xpla

### Automatic Installer
You can setup your Xpla fullnode in few minutes by using automated script below.
```
wget -O xpla.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/xpla/xpla.sh && chmod +x xpla.sh && ./xpla.sh
```
### Public Endpoint

>- API : https://rest.xpla.nodexcapital.com
>- RPC : https://rpc.xpla.nodexcapital.com
>- gRPC : https://grpc.xpla.nodexcapital.com

### Snapshot
```
sudo systemctl stop xplad
cp $HOME/.xpla/data/priv_validator_state.json $HOME/.xpla/priv_validator_state.json.backup
rm -rf $HOME/.xpla/data

curl -L https://snap.nodexcapital.com/xpla/xpla-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.xpla/
mv $HOME/.xpla/priv_validator_state.json.backup $HOME/.xpla/data/priv_validator_state.json

sudo systemctl start xplad && sudo journalctl -fu xplad -o cat
```

### State Sync
```
sudo systemctl stop xplad
cp $HOME/.xpla/data/priv_validator_state.json $HOME/.xpla/priv_validator_state.json.backup
xplad tendermint unsafe-reset-all --home $HOME/.xpla

STATE_SYNC_RPC=https://rpc.xpla.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.xpla/config/config.toml

mv $HOME/.xpla/priv_validator_state.json.backup $HOME/.xpla/data/priv_validator_state.json

sudo systemctl start xplad && sudo journalctl -u xplad -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.xpla/config/config.toml
sudo systemctl restart xplad && journalctl -u xplad -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.xpla.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.xpla/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/xpla/addrbook.json > $HOME/.xpla/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/xpla/genesis.json > $HOME/.xpla/config/genesis.json
```