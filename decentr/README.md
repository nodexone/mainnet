<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://decentr.net/assets/img/logo-blue.svg">
</p>

# Decentr Mainnet | Chain ID : mainnet-3 | Custom Port : 108

### Community Documentation:
>- [Indonode Node Installation](https://www.indonode.net/mainnet/decentr)

### Explorer:
>-  https://explorer.nodexcapital.com/decentr

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Decentr fullnode in few minutes by using automated script below.
```
wget -O decentr.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/decentr/decentr.sh && chmod +x decentr.sh && ./decentr.sh
```
### Public Endpoint

>- API : https://rest.decentr.nodexcapital.com
>- RPC : https://rpc.decentr.nodexcapital.com
>- gRPC : https://grpc.decentr.nodexcapital.com

### Snapshot
```
sudo systemctl stop decentrd
cp $HOME/.decentr/data/priv_validator_state.json $HOME/.decentr/priv_validator_state.json.backup
rm -rf $HOME/.decentr/data

curl -L https://snap.nodexcapital.com/decentr/decentr-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.decentr/
mv $HOME/.decentr/priv_validator_state.json.backup $HOME/.decentr/data/priv_validator_state.json

sudo systemctl start decentrd && sudo journalctl -fu decentrd -o cat
```

### State Sync
```
sudo systemctl stop decentrd
cp $HOME/.decentr/data/priv_validator_state.json $HOME/.decentr/priv_validator_state.json.backup
decentrd tendermint unsafe-reset-all --home $HOME/.decentr

STATE_SYNC_RPC=https://rpc.decentr.nodexcapital.com:443
STATE_SYNC_PEER=a6ebaed2c7972941b5cce5d94ec94a1352a600a4@peers-decentr.sxlzptprjkt.xyz:31656 
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.decentr/config/config.toml

mv $HOME/.decentr/priv_validator_state.json.backup $HOME/.decentr/data/priv_validator_state.json

sudo systemctl start decentrd && sudo journalctl -u decentrd -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.decentr/config/config.toml
sudo systemctl restart decentrd && journalctl -u decentrd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.decentr.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.decentr/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/decentr/addrbook.json > $HOME/.decentr/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/decentr/genesis.json > $HOME/.decentr/config/genesis.json
```