### Working directory
First of all, we are going to set up a new working directory and change into it.

```bash
mkdir ./nft
cd nft/
```

### Set variables
We will set important values in a more readable variable for better readability and debugging of failed transactions.

Since cardano-node version **1.31.0 the token name should be in hex format**. 
We will set the variable $realtokenname (real name in utf-8) and then convert it to $tokenname (name in hex format). 

### NOTE: set the $TESTNET id to preview / preprod as required.
```bash
realtokenname="NFT1"
tokenname=$(echo -n $realtokenname | xxd -b -ps -c 80 | tr -d '\n')
tokenamount="1"
fee="0"
output="0"
ipfs_hash="please insert your ipfs hash here"
```
:::note
The IPFS hash is a key requirement and can be found once you upload your image to IPFS. Here's an example of how the IPFS looks like when an image is uploaded in [pinata](https://pinata.cloud/)
![img](./emurgoacademy.jpeg)
:::


### Generate keys and address

We will be generating new keys and a new payment address:

```bash
cardano-cli address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
```

Those two keys can now be used to generate an address.

```bash
cardano-cli address build --payment-verification-key-file payment.vkey --out-file payment.addr $TESTNET
```

We will save our address hash in a variable called address.

```bash
address=$(cat payment.addr)
```

### Fund the address

Submitting transactions always require you to pay a fee. 
Sending native assets requires sending at least 1 ada.  
So make sure the address you are going to use as the input for the minting transaction has sufficient funds. 
For our example, the newly generated address was funded with 10 ada.

```bash
cardano-cli query utxo --address $address $TESTNET
```

You should see something like this.
```bash
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
974e98c4529f8fc75fa8baf5618f7b5ade81aa9ed29ce33cd1c2f2e70838180e     0        10000000 lovelace
```
### Export protocol parameters

For our transaction calculations, we need some of the current protocol parameters. The parameters can be saved in a file called `protocol.json` with this command:

```bash
cardano-cli query protocol-parameters $TESTNET --out-file protocol.json
```

### Creating the policyID
Just as in generating native assets, we will need to generate some policy-related files like key pairs and a policy script.

```bash
mkdir policy
```

:::note
We don’t change into this directory, and everything is done from our working directory.
:::

Generate a new set of key pairs:

```bash
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey
```

Instead of only defining a single signature (as we did in the native asset minting guide), our script file needs to implement the following characteristics (which we defined above):

1. Only one signature allowed
2. No further minting or burning of the asset allowed after 10000 slots have passed since the transaction was made


### Make a new file called policy.script in the policy folder 
```bash
touch policy/policy.script
```
Paste the JSON from above, populated with your `keyHash` and your `slot` number into it
```bash
nano policy/policy.script
```

`policy.script` file which will look like this:

```json
{
  "type": "all",
  "scripts":
  [
    {
      "type": "before",
      "slot": <insert slot here>
    },
    {
      "type": "sig",
      "keyHash": "insert keyHash here"
    }
  ]
}
```

And save the location of the script file into a variable as well.

```bash
script="policy/policy.script"
```

Now as you can see in the above policy script, we need to adjust two values here, the `slot` number as well as the `keyHash`.

### To generate the `keyHash`, use the following command:
```bash
cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey
```

### NOTE: 
**For this exercise, please set the key hash and correct slot manually.**

To calculate the correct slot, query the current slot and add 10000 to it:
```bash
cardano-cli query tip $TESTNET
```
:::note
Be aware the slot number is defined as an integer and therefore needs no double quotation marks, whereas the `keyHash` is defined as a string and needs to be wrapped in double quotation marks.
:::

The last step is to generate the policyID:

```bash
cardano-cli transaction policyid --script-file ./policy/policy.script > policy/policyID
```

### Metadata
Since we now have our policy as well as our `policyID` defined, we need to adjust our metadata information.

Here’s an example of the metadata.json which we’ll use for this guide:

```json
{
        "721": {
            "please_insert_policyID_here": {
              "NFT1": {
                "description": "This is my first NFT thanks to the Cardano foundation",
                "name": "Cardano foundation NFT guide token",
                "id": 1,
                "image": ""
              }
            }
        }
}
```

:::note
Please make sure the image value / IPFS hash is set with the correct protocol pre-fix <i>ipfs://</i>  
(for example <i>"ipfs://QmRhTTbUrPYEw3mJGGhQqQST9k86v1DPBiTTWJGKDJsVFw"</i>)


:::note
The third element in the hierarchy needs to have the same name as our NFT native asset.
:::

Save this file as `metadata.json`. 

:::
### Crafting the transaction

Let's begin building our transaction.
Before we start, we will again need some setup to make the transaction building easier.
Query your payment address and take note of the different values present.

```bash
cardano-cli query utxo --address $address $TESTNET
```

Your output should look something like this (fictional example):

```bash
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
b35a4ba9ef3ce21adcd6879d08553642224304704d206c74d3ffb3e6eed3ca28     0        1000000000 lovelace
```

Since we need each of those values in our transaction, we will store them individually in a corresponding variable.
### NOTE: set the era as per network (--babbage-era for preview network, --alonzo-era for preprod network)

```bash
era="--babbage-era"
utxoin="insert your txhash here followed by # followed by the index"
funds="insert Amount in lovelace here"
policyid=$(cat policy/policyID)
output=1400000
```

Here we are setting the `output` value to `1400000` Lovelace which is equivalent to `1.4` ADA. 
This amount is used because this is the minimum UTxO requirement.

If you're unsure, check if all of the other needed variables for the transaction are set:

```bash
echo $era
echo $TESTNET
echo $fee
echo $address
echo $output
echo $tokenamount
echo $policyid
echo $tokenname
echo $slotnumber
echo $script
```

If everything is set, run the following command:



```bash
cardano-cli transaction build \
$era \
--tx-in $utxoin \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
--change-address $address \
--mint="$tokenamount $policyid.$tokenname" \
--minting-script-file $script \
--metadata-json-file metadata.json  \
--invalid-hereafter $slotnumber \
--witness-override 2 \
--out-file matx.raw $TESTNET

```

The above command may generate output as per below:

```bash
Minimum required UTxO: Lovelace 1448244
```

This means that we need to change the value of the `$output` variable to the given value.
### NOTE: The above step might need to be done TWICE until the min. required utxo is not changing in value. 
### This is due to the fact that the first iteration changes the storage requirement, and hence we might need to stabilize the estimate based 
### upon the final size.

```
output=1448244
```

Remember to use the value that you got in your own output. 
If the minimum value was right then this command will generate `matx.raw` and will give output similar to:

```bash
Estimated transaction fee: Lovelace 176677
```

__NOTE__: Its possible that the Lovelace value for you is different.

Sign the transaction

```bash
cardano-cli transaction sign  \
--signing-key-file payment.skey  \
--signing-key-file policy/policy.skey  \
$TESTNET --tx-body-file matx.raw  \
--out-file matx.signed
```

:::note
The signed transaction will be saved in a new file called <i>matx.signed</i> instead of <i>matx.raw</i>.
:::

Now we are going to submit the transaction, therefore minting our native assets:
```bash
cardano-cli transaction submit --tx-file matx.signed $TESTNET
```

Congratulations, we have now successfully minted our own token.
After a couple of seconds, we can check the output address
```bash
cardano-cli query utxo --address $address $TESTNET
```

and should see something like this:

### Displaying your NFT

One of the most adopted NFT browsers is [pool.pm](https://pool.pm/tokens).
Enter your address in the search bar, hit enter, and your NFT will be displayed with all its attributes and the corresponding image.


![img](../../static/img/nfts/poolpm_nft.png)


You can check it out yourself and see the NFT created for this tutorial [here](https://pool.pm/6574f051ee0c4cae35c0407b9e104ed8b3c9cab31dfb61308d69f33c.NFT1).


## Burn your token

If you messed something up and want to re-start, you can always burn your token if the slot defined in your policy script isn't over yet.
Assuming you have still every variable set, you need to re-set:

```bash
burnfee="0"
burnoutput="0"
utxoin="insert your txhash here followed by # followed by the index"
burnoutput=1400000
```

The transaction looks like this:

```bash
cardano-cli transaction build \
$era \
--tx-in $utxoin --tx-out $address+$burnoutput --mint="-1 $policyid.$tokenname" \
--minting-script-file $script \
--change-address $address \
--invalid-hereafter $slot \
--witness-override 2 \
--out-file burning.raw $TESTNET
```

:::note
The minting parameter is now called with a negative value, therefore destroying one token.
:::


Sign the transaction.
```bash
cardano-cli transaction sign  --signing-key-file payment.skey  --signing-key-file policy/policy.skey $TESTNET  --tx-body-file burning.raw --out-file burning.signed
```
Full send.
```bash
cardano-cli transaction submit --tx-file burning.signed $TESTNET
```

Congrats! You've completed the NFT exercises!

