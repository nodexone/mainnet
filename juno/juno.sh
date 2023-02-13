#
# // Copyright (C) 2022 Salman Wahib Recoded By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Cosmovisor Automatic Installer for Juno | Chain ID : juno-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=juno
WALLET=wallet
BINARY=junod 
FOLDER=.juno
CHAIN=juno-1 
VERSION=v11.0.0
DENOM=ujuno
COSMOVISOR=cosmovisor
REPO=https://github.com/CosmosContracts/juno
GENESIS=https://snapshots.polkachu.com/genesis/juno/genesis.json
ADDRBOOK=https://snapshots.polkachu.com/addrbook/juno/addrbook.json
PORT=11


echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NODENAME ]; then
	read -p "hello@nodexcapital:~# [ENTER YOUR NODE] > " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[35m$NODENAME\e[0m"
echo -e "NODE CHAIN CHAIN  : \e[1m\e[35m$CHAIN\e[0m"
echo -e "NODE PORT      : \e[1m\e[35m$PORT\e[0m"
echo ""

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# Get mainnet version of planq
cd $HOME
rm -rf $SOURCE
git clone $REPO
cd $SOURCE
git checkout $VERSION
make install
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv $HOME/go/bin/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

# Init generation
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend file
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

# Set peers and seeds
PEERS=966d30b8a5c0e696e23014b1e5512b65e50014a3@212.102.34.6:38656,134d8c28fdfac3f38fd9db7ee8f7685b3564a413@142.132.248.214:26656,77a62d703a87a783e18599bc7fea781de02e7967@5.9.97.174:15610,285b8d9cabcc9423b419c603c9d5e4cf216082e0@74.118.140.100:26656,08a5984d7e15706c2331e991a37d6243d38f2744@89.149.218.68:26656,a3b9b97aba75a6c495f028240146fdcf2a40adf8@89.149.218.192:26656,92b79ad186c43cecaace2e715afd29fb483d44af@95.217.12.116:26656,069e299debe27f6d693e7a0703232067d63da683@51.81.107.95:10556,dbaf5bfd765b6b44ee6283d0dc93a71453ea45d2@15.235.9.63:16188,b9f18cfdcec405987335681eccb5ab3288225846@141.95.155.224:10056,b2aacd71ee365d97a2ae0e9c556e0b4632cdd62b@198.244.203.179:26656,a787b5091f4740cde316384087b5f1deecbcceaf@148.251.89.143:28050,1fdc7232c89dbadf42c92368ebc0b4f44f570274@51.81.107.151:26656,29c977de6302fa8ad6861ef0b1a30cb670151f5d@172.105.110.122:2070,9f8cd938d81d4232517ac1d29bd1510e3aac5ce4@146.59.52.95:33095,8f3cbef6dc58d31bb70655d3d3c40d66d4744033@137.184.32.93:26656,5fac7df941e4822a51c18f2dda6b383374b6ddf9@43.135.186.183:26656,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,650d04a352266084f2f37bd9f89eb0a9b892049a@198.244.213.94:22356,65c708782d179235fb6ec90f8cf8ee4b6eb908a4@38.146.3.141:12656,a41df74bb4a1f83af77b47c32daf86176b3e6533@162.19.171.42:10056,b212d5740b2e11e54f56b072dc13b6134650cfb5@169.155.45.114:26656,531601a86419128f5d2752c13da8d378d3e84a4e@95.217.121.45:26656,0099e13cdaf9f9c88aadc2fad6271dc10a2860c4@88.208.242.3:26656,c8475a7d7dd5d0e37e074f297d8c9dffaa41de6c@57.128.75.17:28050,2532887834e05d3578006a96d0bb55e8020c9c5f@173.215.85.171:20070,45f4da091b7f7536c3e0182083ff2326d0c3be6a@66.85.137.122:26656,28aac28c5de2fb26b0ba23221e9173d9cd1a614c@65.108.11.167:29519,0d9949d16394ea8423bf637bbc67d67b23b14058@122.155.165.127:26656,b49e28c215096323f20dba05929f9f4c1f6b58a8@65.108.142.81:26664,8b72c3445e3bbc9cb73c2902e6c7349dd21e2796@198.244.202.196:26656,093bb41c023236cc1d2e9218067fc3fd59362fc8@65.109.67.119:26656,9ab97871aed56d465df84149e1b3a1cc2a90a74d@65.108.98.235:28856,f057079b5b5d458e7a73a454f41e58127c754071@65.109.113.86:26656,4d1468f230067003a9d4e6d7dd70f82311c5e304@65.108.139.112:26656,d2247f7b919f0781c90ee61958d7044665a22d38@169.155.169.197:26656,6c96d922cd883e59da1d8271f9fd23d827d5f920@45.84.138.196:26656,839088f5507a45d1cee03739f741d87749868009@198.244.165.175:16656,b8a68b10d8dd004e766693333344eead31278e24@65.144.145.234:26656,2770c544ebe56d6408d545abc6c57d84fb064e4e@147.182.233.6:26656,9135a94392c4793e89902554e9446df708e14a18@176.9.7.37:26656,2ed6df7c98ca4ef9c40fcdce255daf56e3e502d5@51.81.208.3:26656,fdbbf603e09e1fffb54518ea8bf5ebc9a7b95152@93.189.30.70:26656,fd29227cd0971725542a10173bbc629ecd074666@47.156.153.124:39656,70fcee92283edc02340289b2a74e4ab1a0203848@116.202.236.59:39656,c11bbb68486bdbff6e19f3eec029686b6d5eac32@65.108.121.190:2030,7d5548102518ef89a988960afcccba2504707a08@162.55.92.114:2030,6efb105cc8b8753f998af85f20cece903997fa31@13.124.232.81:26656,123d04c1af282c9041835e17598a0e909d1bd5af@198.244.202.140:26656,4a0991be53ff3d42f0cd9e4c7fc3eed3d7584ce8@213.133.100.164:26656,997d779d56158c83033b37e431b72e87e94ee763@62.84.121.13:26656,e7c642bdd79fd79cd2677f4f8b1351236b5ec2f3@204.16.241.208:26656,c5e19d1e923d83a44a4d4c00a1cd408503a1fc87@198.244.203.181:26656,f3cee9895a0be20067b1aa2ca3fd7ede59ee0b71@83.149.102.56:33095,06c148ff53e9c2021e0d37f4d9b05ae97fb8aa07@50.21.167.145:26656,eee69cc98a6d5e336164697188ed2eb3631dce8c@85.237.193.95:26656,f90ab44ae1c38915a99d0c1605b64989d543ad72@51.81.208.145:26656,1dd6670f5bb6fd3f8161bd0d4ff0a01cf83e9cb9@65.108.207.236:26656,60493cb0f123f7717bfcb4432539a0a37a02df97@65.108.64.5:26656,f8c768174bf4842d64d823fb434b0847d71145c0@5.9.49.11:26656,8222761893d968ba0df4fc7e1677a66b532cb185@195.3.223.110:26656,f790b6c1ed813471b9ef78f3f6b77ac7f12a1fb2@144.126.217.120:26656,e6f704d1f70be15e345e1802002ec1034179306e@65.108.71.166:64656,75da2dbd926508f82ba74b6763155227ff3c8070@65.109.33.108:26656,453ad4c22bf399b4b2a439ea841fd9734f30a5ef@185.225.191.108:26656,a26afc91bb6ec81099c56e87ede2986b40528c8a@65.108.235.46:26656,8656957a311dc882523654e25a1d8e2f014cd353@65.108.77.106:26656,a492330151835e4cbc8c7bca2d77007a4ff2178e@65.21.235.147:26656,7832e05394c2251c6e6a5a1caf7b660f1fe403d7@195.3.223.108:36656,2dded894a785d1d3b411aaf6fb88fda719d4b40d@135.181.215.115:26636,2d473ca3eb1cd728155ea12eb0b301eebccaec5e@162.19.89.8:10556,08c31507bcf5140c559435bcbb2619e4c3675be1@195.3.221.21:12656,97f76286b6815e84c6bd457beb7c59d821c0b852@141.95.72.198:26656,32e56362f47c425328bd29bfa913fe188de4c69e@51.38.53.101:26620,44294f4bbeeb751d6a2f1d84dfeb8b9224f5acb8@135.181.116.165:26656,e144330f2b0d08b0d1ac3a51e55add8a57fcc3ac@35.247.5.192:26656,4deec88245f034335552e0f615d4f76c52c31948@93.189.30.111:26656,5c189bb73ae43a6fee13794d5833f131c227985c@99.79.95.224:26603,68a3fa7bb4253b227dba2ca55da567b37c18a59d@18.206.199.98:26656,e17f6c3d906aaaf0f6f05cd1e330986bde51178e@65.108.104.149:27656,46af91c713ab4119b1f938528877299edb631a7d@5.161.49.37:36656,838f26120c727f842ecdfd1b5aa014f13cf29d57@142.132.205.120:12656,1e95f780f110ca2335ecd09dca1927a9b5bb0090@154.12.241.136:26656,d83892be2e6efc38e255943ce86ae8229d2aee90@178.128.220.188:26656,89757803f40da51678451735445ad40d5b15e059@169.155.44.89:26656,155de67d7cd7f63c7aa070b9f99ab806736ba124@74.96.207.58:25656,29b7ac8939ad9272f24849b259d7d2764e252151@52.213.191.239:26656,169022205f5811e2a0b31b6d3cf11e8a6dfb8242@116.202.192.156:26656,40997aba1e7ba57960e29f2086ef5d4f952849b2@51.89.7.236:26620,efe1a34f49a0342257fd0ba3ca5ea20e51ee77d5@95.217.219.151:26656,9fae88f5e878f99856fbdbcf230a01c1c6c9cf7f@57.128.133.6:26656,ecb1f2a5feef0a3406235b1fd7531484df95f20f@27.72.97.236:26656,b533b7bc9bcd2d023976f0a8d22bf921000ccc38@116.203.136.179:36656,d7587af3ec9d29f0c3742aebeb17d2463b07f4c5@5.161.125.124:36656,2832bdb0a1bdddb2b17d1229a799290222c085d0@135.125.189.131:33095,04d658d9d86698846d1ae0e3e34fead99ee44a3c@18.163.129.138:26656,37eeafbe61d4a0b32421d20578df7eb06ebeeba2@168.119.50.205:36656,c44a49da8adf6ab86a26c9b7fa53da179597605b@85.10.243.90:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@135.181.5.219:12656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:12656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$FOLDER/config/config.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snapshots.polkachu.com/snapshots/juno/juno_6970469.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

# Create Service
sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl start $BINARY

echo -e "\e[1m\e[35mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End