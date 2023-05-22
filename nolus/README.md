<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/cosmos-images/main/logos/nolus.png">
</p>

# Nolus Mainnet | Chain ID : pirin-1 | Custom Port : 123

### Community Documentation:
>- [NodeX Capital Resource](https://services.kjnodes.com/home/mainnet/nolus/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/nolus

### Automatic Installer
You can setup your nolus fullnode in few minutes by using automated script below.
```
wget -O nolus.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/nolus/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```
### Public Endpoint

>- API : https://rest.nolus.nodexcapital.com
>- RPC : https://rpc.nolus.nodexcapital.com
>- gRPC : https://grpc.nolus.nodexcapital.com

### Snapshot
```
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus/
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl start nolusd && sudo journalctl -fu nolusd -o cat
```

### State Sync
```
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
nolusd tendermint unsafe-reset-all --home $HOME/.nolus

STATE_SYNC_RPC=https://rpc.nolus.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.nolus/config/config.toml

mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.nolus/config/config.toml
sudo systemctl restart nolusd && journalctl -u nolusd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.nolus.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.nolus/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/nolus/addrbook.json > $HOME/.nolus/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/nolus/genesis.json > $HOME/.nolus/config/genesis.json
```