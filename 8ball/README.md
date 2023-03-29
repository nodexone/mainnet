<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://explorer.genznodes.dev/logos/8ball.png">
</p>

# 8Ball Mainnet | Chain ID : eightball-1 | Custom Port: 110

### Community Documentation:
>- [Validator setup instructions](https://github.com/nodexcapital/mainnet/blob/main/8ball/README.md)

### Explorer:
>-  https://explorer.nodexcapital.com/8ball

### Automatic Installer
You can setup your 8Ball fullnode in few minutes by using automated script below.
```
wget -O 8ball.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/8ball/8ball.sh && chmod +x 8ball.sh && ./8ball.sh
```
### Public Endpoint

>- API : https://rest.8ball.nodexcapital.com
>- RPC : https://rpc.8ball.nodexcapital.com
>- gRPC : https://grpc.8ball.nodexcapital.com

### Snapshot
```
sudo systemctl stop 8ball
cp $HOME/.8ball/data/priv_validator_state.json $HOME/.8ball/priv_validator_state.json.backup
rm -rf $HOME/.8ball/data

curl -L https://snap.nodexcapital.com/8ball/8ball-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.8ball/
mv $HOME/.8ball/priv_validator_state.json.backup $HOME/.8ball/data/priv_validator_state.json

sudo systemctl start 8ball && sudo journalctl -fu 8ball -o cat
```

### State Sync
```
8ball tendermint unsafe-reset-all --home $HOME/.8ball --keep-addr-book

SNAP_RPC="http://rpc.8ball.nodexcapital.com:11057"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.8ball/config/config.toml

sudo systemctl start 8ball && sudo journalctl -fu 8ball -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.8ball.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.8ball/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/8ball/addrbook.json > $HOME/.8ball/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/8ball/genesis.json > $HOME/.8ball/config/genesis.json
```