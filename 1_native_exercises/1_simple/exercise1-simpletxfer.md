# Simple Sample - Value Transfer to another address

## Part 1 Create a new set of keys and address 

Set up the node socket path (if required)

    export CARDANO_NODE_SOCKET_PATH=$HOME/latest/node.socket (adapt this to your particular folder)
    export TESTNET="--testnet-magic 2"

### Note: The Below steps will help you setup an address and fund it with testAda.
### SKIP THIS PART IF YOU ALREADY HAVE A PAYMENT address.
If not, execute the following steps to create the address and fund it with test ada.

    cardano-cli address key-gen \
    --verification-key-file payment.vkey \
    --signing-key-file payment.skey

    cardano-cli stake-address key-gen \
    --verification-key-file stake1.vkey \
    --signing-key-file stake1.skey

    cardano-cli address build \
    --payment-verification-key-file payment.vkey \
    --stake-verification-key-file stake1.vkey \
    --out-file payment.addr \
    $TESTNET
    
 **Fund the payment address with 1000 Test Ada from the Faucet ([ADA Testnet Faucet](https://docs.cardano.org/cardano-testnet/tools/faucet))**

### CONTINUE FROM HERE IF YOU ALREADY HAVE A PAYMENT ADDRESS 
Generate necessary keys for the second account

    cardano-cli address key-gen \
    --verification-key-file payment2.vkey \
    --signing-key-file payment2.skey

    cardano-cli stake-address key-gen \
    --verification-key-file stake2.vkey \
    --signing-key-file stake2.skey

    cardano-cli address build \
    --payment-verification-key-file payment2.vkey \
    --stake-verification-key-file stake2.vkey \
    --out-file payment2.addr \
    $TESTNET


And check the UTxO for the payment address 
    
    cardano-cli query utxo $TESTNET --address $(cat payment.addr)

                               TxHash                                 TxIx        Amount
    --------------------------------------------------------------------------------------
    7b4956b103d47908318ee92aa0790ff4b36fe7940991f0be350c9085fc4da175     1        100000000000 lovelace + TxOutDatumHashNone



Build the transaction using `transaction build` (recommended)
    
    UTXO1=7b4956b103d47908318ee92aa0790ff4b36fe7940991f0be350c9085fc4da175#1

    cardano-cli transaction build \
    --babbage-era \
    --tx-in $UTXO1 \
    --tx-out $(cat payment2.addr)+2500000000 \
    --change-address $(cat payment.addr) \
    $TESTNET \
    --out-file tx.raw

Sign the transaction

    cardano-cli transaction sign \
    $TESTNET \
    --signing-key-file payment.skey \
    --tx-body-file tx.raw \
    --out-file tx.signed

And submit it to the Testnet

    cardano-cli transaction submit $TESTNET  --tx-file tx.signed

The transaction is submitted, if you wnat to know the transaction hash, just type out the command below:

    cardano-cli transaction txid --tx-file tx.signed
    
Check that the result is what you expect

    cardano-cli query utxo $TESTNET  --address $(cat payment2.addr)

                               TxHash                                 TxIx        Amount
    --------------------------------------------------------------------------------------
    7d721d8a0cc2f3d87f44d4df22d6815f58fb67f421b283462ff3b823c36f34a6     1        2500000000 lovelace + TxOutDatumHashNone
