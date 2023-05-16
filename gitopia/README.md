<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://gitopia.com/logo-white.svg">
</p>

# Gitopia Mainnet | Chain ID : gitopia | Custom Port : 122

### Community Documentation:
>- [Kjnodes Node Installation](https://services.kjnodes.com/home/mainnet/gitopia/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/gitopia

### Automatic Installer
You can setup your gitopia fullnode in few minutes by using automated script below.
```
wget -O gitopia.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/gitopia/gitopia.sh && chmod +x gitopia.sh && ./gitopia.sh
```
### Public Endpoint

>- API : https://rest.gitopia.nodexcapital.com
>- RPC : https://rpc.gitopia.nodexcapital.com
>- gRPC : https://grpc.gitopia.nodexcapital.com

### Snapshot
```
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
rm -rf $HOME/.gitopia/data

curl -L https://snap.nodexcapital.com/gitopia/gitopia-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.gitopia/
mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl start gitopiad && sudo journalctl -fu gitopiad -o cat
```

### State Sync
```
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia

STATE_SYNC_RPC=https://rpc.gitopia.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.gitopia/config/config.toml

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl start gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.gitopia/config/config.toml
sudo systemctl restart gitopiad && journalctl -u gitopiad -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.gitopia.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.gitopia/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/gitopia/genesis.json > $HOME/.gitopia/config/genesis.json
```