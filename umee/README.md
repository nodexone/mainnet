<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>


<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/umee.png">
</p>

# Umee Mainnet | Chain ID : umeed-1 | Custom Port : 119

### Community Documentation:
>- [Validator setup instructions](https://polkachu.com/networks/umee)

### Explorer:
>-  https://explorer.nodexcapital.com/umee

### Automatic Installer
You can setup your Umee fullnode in few minutes by using automated script below.
```
wget -O umee.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/umee/umee.sh && chmod +x umee.sh && ./umee.sh
```
### Public Endpoint

>- API : https://rest.umee.nodexcapital.com
>- RPC : https://rpc.umee.nodexcapital.com
>- gRPC : https://grpc.umee.nodexcapital.com

### Snapshot
```
sudo systemctl stop umeed
cp $HOME/.umee/data/priv_validator_state.json $HOME/.umee/priv_validator_state.json.backup
rm -rf $HOME/.umee/data

curl -L https://snap.nodexcapital.com/umee/umee-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.umee/
mv $HOME/.umee/priv_validator_state.json.backup $HOME/.umee/data/priv_validator_state.json

sudo systemctl start umeed && sudo journalctl -fu umeed -o cat
```

### State Sync
```
sudo systemctl stop umeed
cp $HOME/.umee/data/priv_validator_state.json $HOME/.umee/priv_validator_state.json.backup
umeed tendermint unsafe-reset-all --home $HOME/.umee

STATE_SYNC_RPC=https://rpc.umee.nodexcapital.com:443
STATE_SYNC_PEER=9cbd857db8203439f294baac260f3f0b677861bf@rpc.umee.nodexcapital.com:11756
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.umee/config/config.toml

mv $HOME/.umee/priv_validator_state.json.backup $HOME/.umee/data/priv_validator_state.json

sudo systemctl start umeed && sudo journalctl -u umeed -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.umee/config/config.toml
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.umee.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.umee/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/umee/addrbook.json > $HOME/.umee/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/umee/genesis.json > $HOME/.umee/config/genesis.json
```