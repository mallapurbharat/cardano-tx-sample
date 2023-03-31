Once you have downloaded (https://github.com/input-output-hk/cardano-node/releases/tag/1.35.5) or built the cardano-node version 1.35.5, please follow the below steps to sync to the preview testnet:

### Download all the config files from the URL https://book.world.dev.cardano.org/environments.html#preview-testnet into ~/testnet/config/preview

### FOLDER ORGANIZATION
- node binaries under $HOME/cardano-node-1.35.5-linux (or macos)
- testnet folder as in  ~/testnet (refer environment variable below)
- preview network configuration files under ~/testnet/config/preview/
- preprod network configuration files under ~/testnet/config/preprod/




UPDATE your .bashrc / .zshrc file accordingly AND RELOAD IT AFTER SAVING IT by either restarting the terminal or running the "source ~/.bashrc" (or .zshrc) file!

## FOR Linux
```
export CARDANO_NODE="$HOME/cardano-node-1.35.6-linux"

export PATH="$CARDANO_NODE:$PATH"
export TESTNETPATH="$HOME/testnet"

#magic id for preview network is 2, preprod 1
export TESTNET="--testnet-magic 2"



#socket path remains same, no change required as we're creating this file ourselves
export CARDANO_NODE_SOCKET_PATH="$TESTNETPATH/node.socket"

alias previewnode='$CARDANO_NODE/cardano-node run --topology $TESTNETPATH/config/preview/topology.json --database-path $TESTNETPATH/db/preview/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $TESTNETPATH/config/preview/config.json'

alias preprodnode='$CARDANO_NODE/cardano-node run --topology $TESTNETPATH/config/preprod/topology.json --database-path $TESTNETPATH/db/preprod/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $TESTNETPATH/config/preprod/config.json'

alias ctip='cardano-cli query tip $TESTNET'


#Added some bash-completion scripts here for ease of execution of commands
source <(cardano-cli --bash-completion-script `which cardano-cli`)
source <(cardano-node --bash-completion-script `which cardano-node`)

function utxo() { cardano-cli query utxo $TESTNET --address $1 ; }
function utxof() { cardano-cli query utxo $TESTNET --address $(cat $1) ; }
function submit() { cardano-cli transaction submit --tx-file $1 $TESTNET ;}

```

## FOR MacOS
```
export CARDANO_NODE="$HOME/cardano-node-1.35.6-macos"

export PATH="$CARDANO_NODE:$PATH"
export TESTNETPATH="$HOME/testnet"

#if there is a space, zsh breaks unless you expand the variable using parentheses
#magic id for preview network is 2, preprod 1
export TESTNET=(--testnet-magic 2)



#socket path remains same, no change required as we're creating this file ourselves
export CARDANO_NODE_SOCKET_PATH="$TESTNETPATH/node.socket"

alias previewnode='$CARDANO_NODE/cardano-node run --topology $TESTNETPATH/config/preview/topology.json --database-path $TESTNETPATH/db/preview/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $TESTNETPATH/config/preview/config.json'

alias preprodnode='$CARDANO_NODE/cardano-node run --topology $TESTNETPATH/config/preprod/topology.json --database-path $TESTNETPATH/db/preprod/ --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config $TESTNETPATH/config/preprod/config.json'

alias ctip='cardano-cli query tip $TESTNET'

function utxo() { cardano-cli query utxo $TESTNET --address $1 ; }
function utxof() { cardano-cli query utxo $TESTNET --address $(cat $1) ; }
function submit() { cardano-cli transaction submit --tx-file $1 $TESTNET ;}

```

## Installation complete! Now to run the cardano-node, just 
## restart the terminal (or run source ~/.bashrc (or .zshrc) 



## To start the cardano-node in preview network , type the command below and hit ENTER
```
previewnode
```
## OR
## To start the cardano-node in prerod network , type the command below and hit ENTER

```
preprodnode
```


## How to deal with common errors.


### if after an improper shut-down, you get the below error

```
cardano-node: The db is used by another process. File "/home/bharat/testnet/db/preview/lock" is locked.
```

then either restart the system or kill the cardano-node process (not recommended!)

```
sudo killall cardano-node
```

### After this kind of an improper shutdown, you might need to delete all the files in the /testnet/db/preview or /testnet/db/preprod folder and resync the database 

For preview network (
### NOTE: use the rm -rf command with care as if it is run in the wrong directory, it can delete important files
### Ensure that you only run it within the testnet/db/.. folder
```
cd $TESTNET/db/preview
rm -rf ./* 
rm -rf ./.*
```
For preprod network
```
cd $TESTNET/db/preprod
rm -rf ./*
rm -rf ./.*
```


Then re-launch the node and it will quickly sync to the latest block (takes only a minute or two right now!)



### NOTE2: Even if your node is working fine, you might keep getting the following type of error (with some variations):
```
TracePromoteColdFailed 50 36 161.97.170.151:3002 161.126402860273s Network.Socket.connect: <socket: 95>: does not exist (Connection refused)


[2022-08-28 16:15:10.52 UTC] TracePromoteColdFailed 50 36 161.97.170.151:3002 160.254143346317s Network.Socket.connect: <socket: 101>: does not exist (Connection refused)

Followed by a new tip message like below
:cardano.node.ChainDB:Notice:33] [2022-08-28 16:15:19.59 UTC] Chain extended, new tip: aa8f7bd7c37182de01ba8adc9dd2752ceaddfd14a99f48fa11b678a6ac6aaba2 at slot 6020119
[Kalpatar:cardano.node.ChainDB:Notice:33] [2022-08-28 16:15:36.44 UTC] Chain extended, new tip: 140c50f6ae9bd015b7e71aaf949694c9833ce92b6df58ddbfb2d169cde7ee78a at slot 6020136
```

Best way is to check if your tip block is changing after a minute or two, if not changing even after two minutes, then you might actually have some problem. :(



## To get some funds from the Ada faucet (WORKING AS OF NOW)
Use this faucet to get preview / preprod ADA: https://docs.cardano.org/cardano-testnet/tools/faucet
