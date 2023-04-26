<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>


<p align="center">
  <img height="100" height="auto" src="https://assets-global.website-files.com/623b58ac191ec545688aee2e/623b6cc4827a57719de4c30a_logo.svg">
</p>

# Point Network Mainnet | Chain ID : point_10687-1 | Custom Port : 118

### Community Documentation:
>- [Validator setup instructions](https://nodestake.top/point)

### Explorer:
>-  https://explorer.nodexcapital.com/point

### Automatic Installer
You can setup your point fullnode in few minutes by using automated script below.
```
wget -O point.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/point/point.sh && chmod +x point.sh && ./point.sh
```
### Public Endpoint

>- API : https://rest.point.nodexcapital.com
>- RPC : https://rpc.point.nodexcapital.com
>- gRPC : https://grpc.point.nodexcapital.com

### Snapshot
```
sudo systemctl stop pointd
cp $HOME/.pointd/data/priv_validator_state.json $HOME/.pointd/priv_validator_state.json.backup
rm -rf $HOME/.pointd/data

curl -L https://snap.nodexcapital.com/point/point-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.pointd/
mv $HOME/.pointd/priv_validator_state.json.backup $HOME/.pointd/data/priv_validator_state.json

sudo systemctl start pointd && sudo journalctl -fu pointd -o cat
```

### State Sync
```
sudo systemctl stop pointd
cp $HOME/.pointd/data/priv_validator_state.json $HOME/.pointd/priv_validator_state.json.backup
pointd tendermint unsafe-reset-all --home $HOME/.pointd

STATE_SYNC_RPC=https://rpc.pointd.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.pointd/config/config.toml

mv $HOME/.pointd/priv_validator_state.json.backup $HOME/.pointd/data/priv_validator_state.json

sudo systemctl start pointd && sudo journalctl -u pointd -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.pointd/config/config.toml
sudo systemctl restart pointd && journalctl -u pointd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.point.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.pointd/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/point/addrbook.json > $HOME/.pointd/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/point/genesis.json > $HOME/.pointd/config/genesis.json
```