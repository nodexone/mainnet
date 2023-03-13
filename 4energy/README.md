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

>- API : https://rest.c4e-m.nodexcapital.com
>- RPC : https://rpc.c4e-m.nodexcapital.com
>- gRPC : https://grpc.c4e-m.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
rm -rf $HOME/.c4e-chain/data

curl -L https://snapshots.kjnodes.com/gitopia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.c4e-chain
mv $HOME/.c4e-chain/priv_validator_state.json.backup $HOME/.c4e-chain/data/priv_validator_state.json

sudo systemctl start c4ed && sudo journalctl -u c4ed -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
c4ed tendermint unsafe-reset-all --home $HOME/.c4e-chain

STATE_SYNC_RPC=https://rpc.c4e-m.nodexcapital.com:443
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
PEERS="64146e3e8a2c360bfacd9f3086d464a659eafe36@65.21.132.27:27356,58923ec776ca59ace9ede4a7211cd1013ae440da@144.76.97.251:33656,792dd2a1b100cd9e8c2b724722e7b0964ef5b107@138.201.85.176:10156,9e5330c3ef248301d81ac18f0634e6d8643a477d@176.9.44.113:26696,d4c6f17b49af7f96c587613cbdb6e41b179079c2@185.208.206.217:26656,d1c10bb6a139ddb29af596fc888bd57c143124b7@93.189.30.124:26656,034b51d46fec0bb90ab0f43575bca3e3dec34ab7@154.53.42.201:2316,9ff8d3da74c505a971c7c83b6befb9e77958eda9@185.219.142.6:26656,cff10605b619e5119a1c9d53397a798de8fbf83b@64.227.136.63:26656,e84d7bff6960e7b50ee8eba09ef6f25b0b0b30cc@95.214.53.105:56656,61a1e4bbc0844df04b8938c17f15f307e5f89cc9@65.21.247.218:26656,c68883e64bc211dbdd3cc2be72cc9fa09f7ddde4@65.109.133.87:26656,7c7c5158c5b67797f85a4e376db8b79da0dadbac@212.109.147.99:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,74b4b2de08686a3de0120b916f09eaf8630475fb@45.88.188.93:46656,ef5b5c188a6e8a20f8d427bb93903e38bedd2690@190.2.136.144:26656,f98c07203f16f60046f4dee9d5c439a5f3918fc2@69.197.43.9:26656,f4b30afd4f46eedfc421272280242cc2fd39e55f@38.242.220.64:16656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.c4e-chain/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/c4e/addrbook.json > $HOME/.c4e-chain/config/addrbook.json
```
### Genesis
```
curl -Ls https:/.nodexcapital.com/c4e/genesis.json > $HOME/.c4e-chain/config/genesis.json
```