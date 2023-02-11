### This Exercise is left to the learner to test his understanding of the UTXO model.

This exercise tries to explain how to submit a more complex transaction where two utxos from DIFFERENT users - user1, user2 can be utilized as inputs to pay out to a user3.

The transaction requires use of the witness-override and witness signing feature of cardano-cli

## High level steps

### query utxo for user 1, create environment variable UTXO1  var in prompt with txid#index 

### query utxo for user 2, create UTXO2 var in prompt with txid#index

### build transaction with two tx-in from user1, user2 and having one tx-out to user3 and change-address to user2 (for example)

### find out about the  "--witness-override" feature of the cardano-cli transaction build command

### witness the transaction using cardano-cli transaction witness command 
you will individually sign the transaction using the above command for user1, user2 using --signing-key-file and --out-file userx.witness for both user1, user2 to create to separate witness files

Assemble the transaction with both witness files and successfully submit it to the testnet
Figure out how this is fundamentally different from the naive implementation of https://developers.cardano.org/docs/integrate-cardano/multi-witness-transactions-cli
    
    
## Additional exercise: Work out how this feature could be used to conduct an ATOMIC swap 
  - Atomic swap meaning that the transaction either succeeds completely, OR FAILS completely
  - For now, assume the swap as below:
  - A has 250 Ada
  - B has 750 Ada
  - the swap tx should EXCHANGE THE two values between A and B
  - since we haven't yet studied native tokens, for now this is limited to swapping value.
  - Later on, we can actually exchange tokens using the same logic
