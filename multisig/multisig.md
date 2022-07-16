

# Multisig transaction
This sample tries to explain how to submit a more complex transaction where funds from a multi-sig policy script are transferred to user4. the policy stipulates that 3 users - user1, user2, user3 need to authorize the transaction for it to succeed.

Credits: [cardano-apexpool ](https://github.com/cardano-apexpool/cardano-scripts/blob/main/multi-signature-address/Readme.md)

The transaction requires use of the witness-override and witness signing feature of cardano-cli

## High level steps

1. create 3 users - user1, user2, user3 verification key, signing key, staking key
## 2. create a 4th user who will get paid - user4 verification key, signing key, staking key

3. generate a keygen hash for user1,2,3 verification keys.
4. create a multisig script which stipulates that all 3 users need to sign the transaction
5. create a script address for this script.
6. fund it with testAda
7. check if funds received by querying utxo
8. create variable to store txid and index
9. build a transaction with witness-override set to 3
10. have each of the users user1,2,3 witness this transaction
11. assemble the transaction to use the raw transaction, witness files together as a signed transaction
12. submit the transaction.
13. verify the balance of user4

## Actual Steps

##### First generate all the account keys that are required
```
cardano-cli address key-gen --verification-key-file payment1.vkey --signing-key-file payment1.skey
cardano-cli stake-address key-gen --verification-key-file stake1.vkey --signing-key-file stake1.skey

cardano-cli address key-gen --verification-key-file payment2.vkey --signing-key-file payment2.skey
cardano-cli address key-gen --verification-key-file payment3.vkey --signing-key-file payment3.skey

cardano-cli stake-address key-gen --verification-key-file stake2.vkey --signing-key-file stake2.skey

KEYHASH1=$(cardano-cli address key-hash --payment-verification-key-file payment1.vkey)
KEYHASH2=$(cardano-cli address key-hash --payment-verification-key-file payment2.vkey)
KEYHASH3=$(cardano-cli address key-hash --payment-verification-key-file payment3.vkey)```
```

##### create a new file called multisigpolicy.script and add the contents as below then fill out the values of KEYHASH1, 2, 3 in the content and save the file

##### NOTE: If you don't replace <KEYHASHX> with an actual key hash, then your script might fail with a cryptic error!
  
```
{
  "type": "all",
  "scripts":
  [
    {
      "type": "sig",
      "keyHash": "<KEYHASH1>"
    },
    {
      "type": "sig",
      "keyHash": "<KEYHASH2>"
    },
    {
      "type": "sig",
      "keyHash": "<KEYHASH3>"
    }
  ]
}
```

##### now we build a script address from the script

`cardano-cli address build --payment-script-file exampletxs/multisigpolicy.script $TESTNET --out-file exampletxs/multisig.addr`

##### now use the [ADA Testnet faucet](https://testnets.cardano.org/en/testnets/cardano/tools/faucet/) to fund this script address with 1000 Ada.

##### check if the funds have been received of 1000 Ada
`cardano-cli query utxo --address $(cat exampletxs/multisig.addr) $TESTNET`

##### take the txid and index and concat them into  a variable UTXO1
`UTXO1=1978adb5f11e9eb8df3042a20c94fa0a7967bc48a487d64c656710ecb895197a#0`


##### build the basic transaction. note the witness-override option
`cardano-cli transaction build --babbage-era --tx-in $UTXO1 --change-address $(cat payment4.addr) --tx-in-script-file exampletxs/multisigpolicy.script --witness-override 3 --out-file txmultisig.raw $TESTNET`

##### view the transaction details
`cardano-cli transaction view --tx-body-file txmultisig.raw`

##### witness the transaction by each user
```
cardano-cli transaction witness --signing-key-file payment1.skey --tx-body-file txmultisig.raw  --out-file payment1.witness

cardano-cli transaction witness --signing-key-file payment2.skey --tx-body-file txmultisig.raw  --out-file payment2.witness

cardano-cli transaction witness --signing-key-file payment3.skey --tx-body-file txmultisig.raw  --out-file payment3.witness
```

##### now assemble all the witness sigs into the transaction
`cardano-cli transaction assemble --tx-body-file txmultisig.raw --witness-file payment1.witness --witness-file payment2.witness --witness-file payment3.witness --out-file txmultisig.signed`

##### now submit the transaction finally
```
cardano-cli transaction submit --tx-file txmultisig.signed $TESTNET
cardano-cli query utxo --address $(cat payment4.addr) $TESTNET
```
Additional step: search for the multisig script address on testnet.cardanoscan.io, you should see a "Contract" heading for the address, and a verify button next to it. Click on the verify button, select the "Native script", this will open up a new window. paste the entire JSON for the multiscript file into the box and click on "Verify". 
  
  
Hope you had fun doing this exercise!
