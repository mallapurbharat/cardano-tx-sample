# Simple Sample - Value Transfer to another address

## Part 1 Create a new set of keys and address payment2 address

### Note: You should have an already existing payment.addr setup with 1000 Test ADA for this follow-up exercise
Set up the node socket path (if required)

    export CARDANO_NODE_SOCKET_PATH=$HOME/latest/node.socket (adapt this to your particular folder)
    export TESTNET="--testnet-magic 2"

Generate necessary keys for second address 

    cardano-cli address key-gen \
    --verification-key-file addr1_2.vkey \
    --signing-key-file addr1_2.skey

    cardano-cli address build \
    --payment-verification-key-file addr1_2.vkey \
    --stake-verification-key-file stake1.vkey \
    --out-file addr1_2.addr \
    $TESTNET
    
### copy the contents below into a new text file
   bech32 <<< $(cat addr1.addr)
   007818c5efb356b33efc1ff9b86901212cadb9f1bbdab55c52dd295de88641d90a1e0aaa84064e21bddfe9c3161d96e0b867d1cb310ff23836
### copy the output below into the same text file on a new line
   bech32 <<< $(cat addr1_2.addr)
 008d755da55a1bc68c43175e40b09d6d102fb97626aa0a036c3a4c760f8641d90a1e0aaa84064e21bddfe9c3161d96e0b867d1cb310ff23836  

You will notice that both the lines have a common hex suffix pattern. This is nothing but the common staking component.

excluding the first two digits (00), copy the part which is uncommon from the above two lines
8d755da55a1bc68c43175e40b09d6d102fb97626aa0a036c3a4c760f


add the prefix of 60 - 6 for enterprise address and 0 for testnet
bech32 addr <<< 608d755da55a1bc68c43175e40b09d6d102fb97626aa0a036c3a4c760f
addr1vzxh2hd9tgdudrzrza0ypvyad5gzlwtky64q5qmv8fx8vrc9c4kld

Now this is an enterprise address created without a staking component which belongs to the wallet but any amount in this address is not staked at all.
