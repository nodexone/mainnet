<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://camo.githubusercontent.com/a5bbca9227cb306b9f2c5d81a0ddbdd0ab30656b95f069a445dbedbca2d3cf87/68747470733a2f2f692e6962622e636f2f785366304b446a2f6334652d6c6f676f2d6c696768742e706e67">
</p>

# C4E Mainnet | Chain ID : perun-1 | Custom Port : 139

Official documentation:
>- [Validator setup instructions](https://www.indonode.net/mainnet/c4e/installation)

Explorer:
>-  https://explorer.nodexcapital.com/c4e

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your planq fullnode in few minutes by using automated script below.
```
wget -O c4e.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/4energy/c4e.sh && chmod +x c4e.sh && ./c4e.sh
```
### Public Endpoint

>- API : https://rest.c4e.nodexcapital.com
>- RPC : https://rpc.c4e.nodexcapital.com
>- gRPC : https://grpc.c4e.nodexcapital.com

### Snapshot
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
rm -rf $HOME/.c4e-chain/data

curl -L https://snap.nodexcapital.com/c4e/c4e-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.c4e-chain
mv $HOME/.c4e-chain/priv_validator_state.json.backup $HOME/.c4e-chain/data/priv_validator_state.json

sudo systemctl start c4ed && sudo journalctl -u c4ed -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
c4ed tendermint unsafe-reset-all --home $HOME/.c4e-chain

STATE_SYNC_RPC=https://rpc.c4e.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.c4e-chain/config/config.toml

mv $HOME/.c4e-chain/priv_validator_state.json.backup $HOME/.c4e-chain/data/priv_validator_state.json

sudo systemctl start c4ed && sudo journalctl -u c4ed -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.c4e.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.c4e-chain/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/c4e/addrbook.json > $HOME/.c4e-chain/config/addrbook.json
```
### Genesis
```
curl -Ls https:/snap.nodexcapital.com/c4e/genesis.json > $HOME/.c4e-chain/config/genesis.json
```