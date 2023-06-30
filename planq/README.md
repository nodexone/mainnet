<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://cdn.builder.io/api/v1/image/assets%2F580ff9284d33405f94bd899116dbdf56%2F1846b26b1cf2456bb5da6004e6629645?format=webp&width=2000">
</p>

# Planq Mainnet | Chain ID : planq_7070-2 | Custom Port : 102

Official documentation:
>- [Validator setup instructions](https://docs.planq.network/validators/quickstart/installation.html/)

Explorer:
>-  https://explorer.nodexcapital.com/planq

### Automatic Installer
You can setup your planq fullnode in few minutes by using automated script below.
```
wget -O planq.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/planq/planq.sh && chmod +x planq.sh && ./planq.sh
```
### Public Endpoint

>- API : https://rest.planq.nodexcapital.com
>- RPC : https://rpc.planq.nodexcapital.com
>- gRPC : https://grpc.planq.nodexcapital.com

### Snapshot
```
sudo systemctl stop planqd
cp $HOME/.planqd/data/priv_validator_state.json $HOME/.planqd/priv_validator_state.json.backup
rm -rf $HOME/.planqd/data

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.planqd/
mv $HOME/.planqd/priv_validator_state.json.backup $HOME/.planqd/data/priv_validator_state.json

sudo systemctl start planqd && sudo journalctl -fu planqd -o cat
```

### State Sync
```
sudo systemctl stop planqd
cp $HOME/.planqd/data/priv_validator_state.json $HOME/.planqd/priv_validator_state.json.backup
planqd tendermint unsafe-reset-all --home $HOME/.planqd

STATE_SYNC_RPC=https://rpc.planq.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.planqd/config/config.toml

mv $HOME/.planqd/priv_validator_state.json.backup $HOME/.planqd/data/priv_validator_state.json

sudo systemctl start planqd && sudo journalctl -u planqd -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.planqd/config/config.toml
sudo systemctl restart planqd && journalctl -u planqd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.planq.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.planqd/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/planq/addrbook.json > $HOME/.planqd/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/planq/genesis.json > $HOME/.planqd/config/genesis.json
```