# Simple Sample - Value Transfer to another address

## Part 1 Create a new set of keys and address payment2 address

### Note: You should have an already existing payment.addr setup with 1000 Test ADA for this follow-up exercise
Set up the node socket path (if required)

    export CARDANO_NODE_SOCKET_PATH=$HOME/latest/node.socket (adapt this to your particular folder)
    export MAGIC="--testnet-magic 1097911063"

Generate necessary keys

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
    ${MAGIC}


And check the UTxO for the payment address 
    
    cardano-cli query utxo ${MAGIC} --address $(cat payment.addr)

                               TxHash                                 TxIx        Amount
    --------------------------------------------------------------------------------------
    7b4956b103d47908318ee92aa0790ff4b36fe7940991f0be350c9085fc4da175     1        100000000000 lovelace + TxOutDatumHashNone



Build the transaction using `transaction build` (recommended)
    
    UTXO1=7b4956b103d47908318ee92aa0790ff4b36fe7940991f0be350c9085fc4da175#1

    cardano-cli transaction build \
    --alonzo-era \
    --tx-in ${UTXO1} \
    --tx-out $(cat payment2.addr)+25000000000 \
    --change-address $(cat payment.addr) \
    ${MAGIC} \
    --out-file tx.raw

or using `transaction build-raw`

    cardano-cli transaction build-raw \
    --alonzo-era \
    --fee 200000 \
    --tx-in ${UTXO1} \
    --tx-out $(cat payment2.addr)+25000000000 \
    --tx-out $(cat payment.addr)+74999800000 \
    --out-file tx.raw

Sign the transaction

    cardano-cli transaction sign \
    ${MAGIC} \
    --signing-key-file payment.skey \
    --tx-body-file tx.raw \
    --out-file tx.signed

And submit it to the Testnet

    cardano-cli transaction submit ${MAGIC}  --tx-file tx.signed


Check that the result is what you expect

    cardano-cli query utxo ${MAGIC}  --address $(cat payment2.addr)

                               TxHash                                 TxIx        Amount
    --------------------------------------------------------------------------------------
    7d721d8a0cc2f3d87f44d4df22d6815f58fb67f421b283462ff3b823c36f34a6     1        25000000000 lovelace + TxOutDatumHashNone
