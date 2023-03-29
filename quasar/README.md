<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/testnet_manuals/main/pingpub/logos/quasar.png">
</p>

# Quasar Mainnet | Chain ID : quasar-1 | Custom Port : 109

### Community Documentation:
>- [Validator setup instructions](https://services.kjnodes.com/home/testnet/quasar/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/quasar

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Quasar fullnode in few minutes by using automated script below.
```
wget -O quasar.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/quasar/quasar.sh && chmod +x quasar.sh && ./quasar.sh
```
### Public Endpoint

>- API : https://rest.quasar.nodexcapital.com
>- RPC : https://rpc.quasar.nodexcapital.com
>- gRPC : https://grpc.quasar.nodexcapital.com

### Snapshot (Update every 12 hours)
```
sudo systemctl stop quasarnoded
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
rm -rf $HOME/.quasarnode/data

curl -L https://snap.nodexcapital.com/quasar/quasar-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.quasarnode/
mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

sudo systemctl start quasarnoded && sudo journalctl -fu quasarnoded -o cat
```

### State Sync
```
sudo systemctl stop quasarnoded
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
quasarnoded tendermint unsafe-reset-all --home $HOME/.quasarnode

STATE_SYNC_RPC=https://rpc.quasar.nodexcapital.com:443
STATE_SYNC_PEER=9cbd857db8203439f294baac260f3f0b677861bf@rpc.quasar.nodexcapital.com:10956
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.quasarnode/config/config.toml

mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

curl -L https://snap.nodexcapital.com/quasar/wasm.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.quasarnode

sudo systemctl start quasarnoded && sudo journalctl -u quasarnoded -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.quasarnode/config/config.toml
sudo systemctl restart quasarnoded && journalctl -u quasarnoded -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.quasar.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.quasarnode/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/quasar/addrbook.json > $HOME/.quasarnode/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/quasar/genesis.json > $HOME/.quasarnode/config/genesis.json
```