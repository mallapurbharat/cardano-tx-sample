This sample tries to explain how to submit a more complex transaction where two utxos from DIFFERENT users - user1, user2 can be utilized as inputs to pay out to a user3.

The transaction requires use of the witness-override and witness signing feature of cardano-cli

High level steps

query utxo for user 1, create environment variable UTXO1  var in prompt with txid#index 
query utxo for user 2, create utxo2 var in prompt with txid#index

build transaction with two tx-in, one tx-out to user3 and change-address to user2 (for example)
use the --witness-override 2 --out-file txmultutxo.raw

transaction view --tx-body-file txmultutxo.raw

witness the transaction using below command for both user1, user2
cardano-cli transaction witness --signing-key-file user1.skey --tx-body-file txmultutxo.raw --out-file user1.witness $TESTNET

cardano-cli transaction assemble --tx-body-file txmultutxo.raw --witness-file user1.witness --witness-file user2.witness --out-file txmultutxo.signed

cardano-cli transaction submit --tx-file txmultutxo.signed $TESTNET
