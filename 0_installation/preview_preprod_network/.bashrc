#magic id for preview network is 2, preprod 1
export TESTNET="--testnet-magic 2"
export CARDANO_NODE_SOCKET_PATH="/ipc/node.socket"

#Added some bash-completion scripts here for ease of execution of commands
source <(cardano-cli --bash-completion-script /usr/local/bin/cardano-cli)
source <(cardano-node --bash-completion-script /usr/local/bin/cardano-node)

alias ctip='cardano-cli query tip $TESTNET'

function utxo() { cardano-cli query utxo $TESTNET --address $1 ; }
function utxof() { cardano-cli query utxo $TESTNET --address $(cat $1) ; }
function submit() { cardano-cli transaction submit --tx-file $1 $TESTNET ;}

