<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/cosmos/chain-registry/master/lumenx/images/lumen.png">
</p>

# LumenX Mainnet | Chain ID: LumenX | Custom Port: 138

### Community Documentation:
>- [Validator setup instructions](https://github.com/nodexcapital/mainnet/tree/main/lumenx)

### Explorer:
>-  https://explorer.nodexcapital.com/lumenx/

### Automatic Installer (Must Using Ubuntu 22 Version!)
You can setup your Arkhadian fullnode in few minutes by using automated script below
```
wget -O lumenx.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/lumenx/lumenx.sh && chmod +x lumenx.sh && ./lumenx.sh
```
### Public Endpoint

>- API : https://rest.lumenx.nodexcapital.com
>- RPC : https://rpc.lumenx.nodexcapital.com
>- gRPC : https://grpc.lumenx.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop lumenxd
cp $HOME/.lumenx/data/priv_validator_state.json $HOME/.lumenx/priv_validator_state.json.backup
rm -rf $HOME/.lumenx/data

curl -L https://snap.nodexcapital.com/lumenx/lumenx-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.lumenx
mv $HOME/.lumenx/priv_validator_state.json.backup $HOME/.lumenx/data/priv_validator_state.json

sudo systemctl start lumenxd && sudo journalctl -u lumenxd -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop lumenxd
cp $HOME/.lumenx/data/priv_validator_state.json $HOME/.lumenx/priv_validator_state.json.backup
lumenxd tendermint unsafe-reset-all --home $HOME/.lumenx

STATE_SYNC_RPC=https://rpc.lumenx-m.nodexcapital.com:443
STATE_SYNC_PEER="bc22063df30a0644df742cdb2764b1004df6e3e3@node1.lumenex.io:26656 9cd5f77ac27254891f64801470b0c3432188c62c@node2.lumenex.io:26656,78669849476c8b728abe178475c6f016edf175cf@node3.lumenex.io:26656,48444a4bacc0cafa049d777152473769ab17c0c3@node4.lumenex.io:26656"
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.lumenx/config/config.toml

mv $HOME/.lumenx/priv_validator_state.json.backup $HOME/.lumenx/data/priv_validator_state.json

sudo systemctl start lumenxd && sudo journalctl -u lumenxd -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.lumenx.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lumenx/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/lumenx/addrbook.json > $HOME/.lumenx/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/lumenx/genesis.json > $HOME/.lumenx/config/genesis.json
```