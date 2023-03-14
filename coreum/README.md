<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/coreum.png">
</p>

# Coreum Mainnet | Chain ID : coreum-mainnet-1 | Custom Port : 141

Official Documentation:
>- [Coreum Documentation](https://docs.google.com/document/d/1h67uVFX4rPZSz0IZwhwgbOnPUiZWcLz4-2si7YXBHwo/edit)

Explorer:
>-  https://explorer.nodexcapital.com/coreum

###Automatic Installer (Cosmovisor)
You can setup your Coreum fullnode using cosmovisor engine in few minutes by using automated script below.
```
wget -O coreum.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/coreum/coreum.sh && chmod +x coreum.sh && ./coreum.sh
```

### Public Endpoint

>- API : https://rest.coreum.nodexcapital.com
>- RPC : https://rpc.coreum.nodexcapital.com
>- gRPC : https://grpc.coreum.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop cored
cp $HOME/.core/coreum-mainnet-1/data/priv_validator_state.json $HOME/.core/coreum-mainnet-1/priv_validator_state.json.backup
rm -rf $HOME/.core/coreum-mainnet-1/data

curl -L https://snap.nodexcapital.com/coreum/coreum-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.core/coreum-mainnet-1
mv $HOME/.core/coreum-mainnet-1/priv_validator_state.json.backup $HOME/.core/coreum-mainnet-1/data/priv_validator_state.json

sudo systemctl start cored && sudo journalctl -u cored -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop cored
cp $HOME/.core/coreum-mainnet-1/data/priv_validator_state.json $HOME/.core/coreum-mainnet-1/priv_validator_state.json.backup
cored tendermint unsafe-reset-all --home $HOME/.core/coreum-mainnet-1

STATE_SYNC_RPC=https://rpc.coreum.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.core/coreum-mainnet-1/config/config.toml

mv $HOME/.core/coreum-mainnet-1/priv_validator_state.json.backup $HOME/.core/coreum-mainnet-1/data/priv_validator_state.json

sudo systemctl start cored && sudo journalctl -u cored -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.core/coreum-mainnet-1/config/config.toml
sudo systemctl restart cored && journalctl -u cored -f -o cat
```

### Live Peers
```
PEERS="92b67a34dbda739a92cd04561ac8c33bfa858477@34.67.59.88:26656,8cedd961a72c183686e9b0b67b6e54fccd6471c3@35.194.10.107:26656,55cec213e8f3738d2642147d857afab93b1a4ef6@34.172.192.61:26656,094189cad7921baf44c280ee8efed959869f3a22@34.66.215.21:26656,eeb17ff4b1dad8d20fdafc339c277f7a624bb84a@35.238.253.76:26656,81e76bc013acbb2048e7acfb2ab04d80732a3699@34.122.166.246:26656,38373344dcb4bbd9e3ce05ecd5ac810079571863@35.202.65.41:26656,2505072cc9586c0c4fafa092a2352123d8c12936@34.28.225.76:26656,62b207017a272a1452ebe7e67018a4f6be1146d8@34.172.201.60:26656,d4801d6777572a8f084e94a1c812fdffb27094c1@35.184.243.26:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/"" $HOME/.core/coreum-mainnet-1/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/coreum/addrbook.json > $HOME/.core/coreum-mainnet-1/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/coreum/genesis.json > $HOME/.core/coreum-mainnet-1/config/genesis.json
```