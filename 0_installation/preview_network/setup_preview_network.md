Once you have built the cardano-node version 1.35.3, please follow the below steps to sync to the preview testnet:

### FOLDER ORGANIZATION
- node binaries under $HOME/cardano-node-1.35.3-linux
- testnet folder under $TESTNETPATH/ (refer environment variable below)
- preview network configuration files under $TESTNETPATH/config/preview/
- legacy network configuration files under $TESTNETPATH/config/legacy/
- preview database under $TESTNETPATH/db/preview/
- legacy database under $TESTNETPATH/db/legacy/
- node.socket under $TESTNETPATH


UPDATE your .bashrc file accordingly

```
export LEGACYNODE="$HOME/cardano-node-1.35.2-linux"
export PREVIEWNODE="$HOME/cardano-node-1.35.3-linux"
#put the preview node path first in path
export PATH="$PREVIEWNODE:$LEGACYNODE:$PATH"

#magic id for preview network is 2
export TESTNET="--testnet-magic 2"
# legacy magic id
# export TESTNET="--testnet-magic 1097911063"

#socket path remains same, no change required as we're creating this file ourselves
export CARDANO_NODE_SOCKET_PATH="$HOME/testnet/node.socket"

alias previewnode='$PREVIEWNODE/cardano-node run --topology $TESTNETPATH/config/preview/topology.json --database-path $TESTNETPATH/db/preview/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $TESTNETPATH/config/preview/config.json'

alias legacynode='$CARDANOPATH/cardano-node run --topology $HOME/testnet/config/testnet-topology.json --database-path $HOME/testnet/db/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $HOME/testnet/config/testnet-config.json'

alias ctip='cardano-cli query tip $TESTNET'

#Added some bash-completion scripts here for ease of execution of commands
source <(cardano-cli --bash-completion-script `which cardano-cli`)
source <(cardano-node --bash-completion-script `which cardano-node`)

function utxo() { cardano-cli query utxo $TESTNET --address $1 ; }
function utxof() { cardano-cli query utxo $TESTNET --address $(cat $1) ; }
function submit() { cardano-cli transaction submit --tx-file $1 $TESTNET ;}

```

### if after an improper shut-down, you get the below error

```
cardano-node: The db is used by another process. File "/home/bharat/testnet/db/preview/lock" is locked.
```

then either restart the system or kill the cardano-node process (not recommended!)

```
sudo killall cardano-node
```

After this kind of an improper shutdown, you might need to delete all the files in the /testnet/db/preview/ folder and resync the database 

```
cd $TESTNET/db/preview
rm -rf ./*
rm -rf ./.*
```

Then re-launch the node and it will quickly sync to the latest block (takes only a minute or two right now!)

At the prompt, type the command below and hit ENTER
```
previewnode

```
