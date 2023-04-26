<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>


<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/sommelier.png">
</p>

# Sommelier Mainnet | Chain ID : sommelier-3 | Custom Port : 117

### Community Documentation:
>- [Validator setup instructions](https://polkachu.com/networks/sommelier)

### Explorer:
>-  https://explorer.nodexcapital.com/sommelier

### Automatic Installer
You can setup your Sommelier fullnode in few minutes by using automated script below.
```
wget -O sommelier.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/sommelier/sommelier.sh && chmod +x sommelier.sh && ./sommelier.sh
```
### Public Endpoint

>- API : https://rest.sommelier.nodexcapital.com
>- RPC : https://rpc.sommelier.nodexcapital.com
>- gRPC : https://grpc.sommelier.nodexcapital.com

### Snapshot (Update every 12 hours)
```
sudo systemctl stop sommelier
cp $HOME/.sommelier/data/priv_validator_state.json $HOME/.sommelier/priv_validator_state.json.backup
rm -rf $HOME/.sommelier/data

curl -L https://snap.nodexcapital.com/sommelier/sommelier-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.sommelier/
mv $HOME/.sommelier/priv_validator_state.json.backup $HOME/.sommelier/data/priv_validator_state.json

sudo systemctl start sommelier && sudo journalctl -fu sommelier -o cat
```

### State Sync
```
sudo systemctl stop sommelier
cp $HOME/.sommelier/data/priv_validator_state.json $HOME/.sommelier/priv_validator_state.json.backup
sommelier tendermint unsafe-reset-all --home $HOME/.sommelier

STATE_SYNC_RPC=https://rpc.sommelier.nodexcapital.com:443
STATE_SYNC_PEER=9cbd857db8203439f294baac260f3f0b677861bf@rpc.sommelier.nodexcapital.com:11756
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.sommelier/config/config.toml

mv $HOME/.sommelier/priv_validator_state.json.backup $HOME/.sommelier/data/priv_validator_state.json

sudo systemctl start sommelier && sudo journalctl -u sommelier -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.sommelier/config/config.toml
sudo systemctl restart sommelier && journalctl -u sommelier -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.sommelier.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.sommelier/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/sommelier/addrbook.json > $HOME/.sommelier/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/sommelier/genesis.json > $HOME/.sommelier/config/genesis.json
```