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

Community Documentation:
>- [Yeksin Validator Installation](https://www.yeksin.net/kyve/installation)

Explorer:
>-  https://explorer.nodexcapital.com/kyve

### Automatic Installer (Non Cosmovisor)
You can setup your Kyve fullnode in few minutes by using automated script below.
```
wget -O kyve.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/kyve/kyve.sh && chmod +x kyve.sh && ./kyve.sh
```

###Automatic Installer (Cosmovisor)
You can setup your Kyve fullnode using cosmovisor engine in few minutes by using automated script below.
```
wget -O kyve-cosmovisor.sh https://raw.githubusercontent.com/nodexcapital/mainnet/main/kyve/kyve-cosmovisor.sh && chmod +x kyve-cosmovisor.sh && ./kyve-cosmovisor.sh
```

### Public Endpoint

>- API : https://rest.kyve.nodexcapital.com
>- RPC : https://rpc.kyve.nodexcapital.com
>- gRPC : https://grpc.kyve.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop kyved
cp $HOME/.kyve/data/priv_validator_state.json $HOME/.kyve/priv_validator_state.json.backup
rm -rf $HOME/.kyve/data

curl -L https://snap.nodexcapital.com/kyve/kyve-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.kyve
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
PEERS="b950b6b08f7a6d5c3e068fcd263802b336ffe047@18.198.182.214:26656,25da6253fc8740893277630461eb34c2e4daf545@3.76.244.30:26656,146d27829fd240e0e4672700514e9835cb6fdd98@34.212.201.1:26656,fae8cd5f04406e64484a7a8b6719eacbb861c094@44.241.103.199:26656,0ab23bfd2924c09a0cb2166a78e65d6d0fbd172a@57.128.162.152:26656,307f4024107ef114dba355fe97dab44b8b45cefc@38.242.253.58:29656,c782ab00baf1c86261db0570307a9ecd9c5b197a@5.9.63.216:28656,443f41172aafaa6c711333c621e019fde3f0ba99@5.75.144.137:26656,86d313c22789ffa50c76b85b460f1e1412782a27@195.3.221.59:12656,a0ba3bd9616b51c26ab6ecc49a30a13d0438ab7f@65.109.94.250:28656,cec6c3c59d1bde0862d27500bf3c0ecc39b4727d@3.144.87.60:31309,0ab23bfd2924c09a0cb2166a78e65d6d0fbd172a@57.128.162.152:26656,cfb5d3dc65e8e1d17285964655d2b47a44d35721@144.76.97.251:42656"
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