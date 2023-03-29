<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://explorer.nodexcapital.com/logos/arkhadian.png">
</p>

# Arkhadian Mainnet | Chain ID : arkh

### Community Documentation:
>- [Validator setup instructions](https://github.com/nodexcapital/mainnet/tree/main/arkhadian)

### Explorer:
>-  https://explorer.nodexcapital.com/arkhadian/

### Automatic Installer (Must Using Ubuntu 22 Version!)
You can setup your Arkhadian fullnode in few minutes by using automated script below
```
wget -O arkh.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/arkhadian/arkh.sh && chmod +x arkh.sh && ./arkh.sh
```
### Public Endpoint

>- API : https://rest.arkh.nodexcapital.com
>- RPC : https://rpc.arkh.nodexcapital.com
>- gRPC : https://grpc.arkh.nodexcapital.com

### Snapshot
```
sudo systemctl stop arkhd
cp $HOME/.arkh/data/priv_validator_state.json $HOME/.arkh/priv_validator_state.json.backup
rm -rf $HOME/.arkh/data

curl -L https://snap.nodexcapital.com/arkh/arkh-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.arkh/
mv $HOME/.arkh/priv_validator_state.json.backup $HOME/.arkh/data/priv_validator_state.json

sudo systemctl start arkhd && sudo journalctl -fu arkhd -o cat
```

### State Sync
```
sudo systemctl stop arkhd
cp $HOME/.arkh/data/priv_validator_state.json $HOME/.arkh/priv_validator_state.json.backup
arkhd unsafe-reset-all --home $HOME/.arkh

STATE_SYNC_RPC=https://asc-dataseed.arkhadian.com:443
STATE_SYNC_PEER=808f01d4a7507bf7478027a08d95c575e1b5fa3c@asc-dataseed.arkhadian.com:26656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.arkh/config/config.toml

mv $HOME/.arkh/priv_validator_state.json.backup $HOME/.arkh/data/priv_validator_state.json

sudo systemctl start arkhd && sudo journalctl -u arkhd -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.arkh.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.arkh/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.nodeist.net/arkh/addrbook.json > $HOME/.arkh/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.nodeist.net/arkh/genesis.json > $HOME/.arkh/config/genesis.json
```