<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://www.yeksin.net/wp-content/uploads/elementor/thumbs/Varlik-32@4x-8-pxec5anprykawqtwuv2ks1ud3j7gnvdq9ats1l3m3y.png">
</p>

# Kyve Networks | Chain ID : kyve-1 | Custom Port : 140

### Community Documentation:
>- [Yeksin Validator Installation](https://www.yeksin.net/kyve/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/kyve

### Automatic Installer
You can setup your Kyve fullnode using cosmovisor engine in few minutes by using automated script below.
```
wget -O kyve-cosmovisor.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/kyve/kyve-cosmovisor.sh && chmod +x kyve-cosmovisor.sh && ./kyve-cosmovisor.sh
```

### Public Endpoint

>- API : https://rest.kyve.nodexcapital.com
>- RPC : https://rpc.kyve.nodexcapital.com
>- gRPC : https://grpc.kyve.nodexcapital.com

### Snapshot
```
sudo systemctl stop kyved
cp $HOME/.kyve/data/priv_validator_state.json $HOME/.kyve/priv_validator_state.json.backup
rm -rf $HOME/.kyve/data

curl -L https://snap.nodexcapital.com/kyve/kyve-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.kyve
mv $HOME/.kyve/priv_validator_state.json.backup $HOME/.kyve/data/priv_validator_state.json

sudo systemctl start kyved && sudo journalctl -u kyved -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop kyved
cp $HOME/.kyve/data/priv_validator_state.json $HOME/.kyve/priv_validator_state.json.backup
kyved tendermint unsafe-reset-all --home $HOME/.kyve

STATE_SYNC_RPC=https://rpc.kyve.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.kyve/config/config.toml

mv $HOME/.kyve/priv_validator_state.json.backup $HOME/.kyve/data/priv_validator_state.json

sudo systemctl start kyved && sudo journalctl -u kyved -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.kyve.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/"" $HOME/.kyve/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/kyve/addrbook.json > $HOME/.kyve/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/kyve/genesis.json > $HOME/.kyve/config/genesis.json
```