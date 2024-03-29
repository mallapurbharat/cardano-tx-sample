These will be the steps we need to take to complete the whole lifecycle:

1. Set everything up
2. Build a new address and keys
3. Generate a minting policy
4. Draft a minting transaction
5. Calculate fees
6. Send the transaction and mint tokens (to ourselves)
7. Send the tokens to a Daedalus wallet 
8. Burn some token 


1. What will be the name of my custom token(s)?  
--> We are going to call `Testtoken`
2. How many do I want to mint?  
--> 10000000 (10M `Testtoken`)
3. Will there be a time constraint for interaction (minting or burning token?)  
---> No (We will discuss this in the next exercise for minting an NFT)
4. Who should be able to mint them?  
--> only one signature (which we possess) should be able to sign the transaction and therefore be able to mint the token

<b>Since cardano-cli version 1.31.0, token names must be base16 encoded </b>.  So here, we use the xxd tool to encode the token names.

```bash
tokenname1=$(echo -n "Testtoken" | xxd -ps | tr -d '\n')
tokenamount="10000000"
output="0"
```



### Set up your workspace

We will start with a clean slate. So let's make a new directory and navigate into it.

```bash
mkdir ./tokens
cd tokens/
```

### NOTE: This guide assumes that you already have addresses with sufficient balance. Save the address in an enviroment variable as below

```bash

address=<INSERT PAYMENT ADDRESS HERE>

```

## Minting native assets

### Generate the policy

Policies are the defining factor under which tokens can be minted. Only those in possession of the policy keys can mint or burn tokens minted under this specific policy.
We'll make a separate sub-directory in our work directory to keep everything policy-wise separated and more organized.
For further reading, please check [the official docs](https://docs.cardano.org/native-tokens/getting-started/#tokenmintingpolicies) or the [github page about multi-signature scripts](https://github.com/input-output-hk/cardano-node/blob/c6b574229f76627a058a7e559599d2fc3f40575d/doc/reference/simple-scripts.md).

```bash
mkdir policy
```

:::note 
We don't navigate into this directory, and everything is done from our working directory.
:::


First of all, we — again — need some key pairs:

```bash
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey
```

Create a `policy.script` file and fill it with an empty string.

```bash
touch policy/policy.script && echo "" > policy/policy.script
```

Use the `echo` command to populate the file:

```bash
echo "{" >> policy/policy.script 
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"," >> policy/policy.script 
echo "  \"type\": \"sig\"" >> policy/policy.script 
echo "}" >> policy/policy.script
```

:::note 
The second echo uses a sub-shell command to generate the so-called key-hash. But, of course, you could also do that by hand.
:::

We now have a simple script file that defines the policy verification key as a witness to sign the minting transaction. There are no further constraints such as token locking or requiring specific signatures to successfully submit a transaction with this minting policy.

### Asset minting
To mint the native assets, we need to generate the policy ID from the script file we created.

```bash
cardano-cli transaction policyid --script-file ./policy/policy.script > policy/policyID
```

The output gets saved to the file `policyID` as we need to reference it later on.

### Build the raw transaction to send to oneself
To mint the tokens, we will make a transaction using our previously generated and funded address.


```bash
utxoin="insert your txhash here followed by # followed by index of the utxo"
funds="insert Amount here"
policyid=$(cat policy/policyID)
```

Also, transactions only used to calculate fees must still have a fee set, though it doesn't have to be exact.  
The calculated fee will be included *the second time* this transaction is built (i.e. the transaction to sign and submit).  
This first time, only the fee parameter *length* matters, so here we choose a maximum value 

```bash
fee="300000"
```

Now we are ready to build the first transaction to calculate our fee and save it in a file called <i>matx.raw</i>.
We will reference the variables in our transaction to improve readability because we saved almost all of the needed values in variables.

This is what our transaction looks like:
```bash
cardano-cli transaction build-raw \
 --fee $fee \
 --tx-in $utxoin \
 --tx-out $address+$output+"$tokenamount $policyid.$tokenname1" \
 --mint "$tokenamount $policyid.$tokenname1" \
 --minting-script-file policy/policy.script \
 --out-file matx.raw
```

:::note 
In later versions of cardano-cli (at least from >1.31.0) <b>the tokennames must be base16 encoded or you will receive an error</b>
```bash
option --tx-out: 
unexpected 'T'
expecting alphanumeric asset name, white space, "+" or end of input
```

You can fix this by redefining the tokennames. In this tutorial the equivalent base16 token name is:
```bash
tokenname1="54657374746F6B656E"
```
:::

#### Syntax breakdown 

```bash
cardano-cli query protocol-parameters $TESTNET --out-file protocol.json

fee=$(cardano-cli transaction calculate-min-fee --tx-body-file matx.raw --tx-in-count 1 --tx-out-count 1 --witness-count 2 $TESTNET --protocol-params-file protocol.json | cut -d " " -f1)
```

Remember, the transaction input and the output of ada must be equal, or otherwise, the transaction will fail. There can be no leftovers.
To calculate the remaining output we need to subtract the fee from our funds and save the result in our output variable.

```bash
output=$(expr $funds - $fee)
```

We now have every value we need to re-build the transaction, ready to be signed. So we reissue the same command to re-build, the only difference being our variables now holding the correct values.

```bash
cardano-cli transaction build-raw \
--fee $fee  \
--tx-in $utxoin  \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname1" \
--mint "$tokenamount $policyid.$tokenname1" \
--minting-script-file policy/policy.script \
--out-file matx.raw
```

Transactions need to be signed to prove the authenticity and ownership of the policy key.

```bash
cardano-cli transaction sign  \
--signing-key-file payment.skey  \
--signing-key-file policy/policy.skey  \
$TESTNET --tx-body-file matx.raw  \
--out-file matx.signed
```

Now we are going to submit the transaction, therefore minting our native assets:
```bash
cardano-cli transaction submit --tx-file matx.signed $TESTNET
```

Congratulations, we have now successfully minted our own token.
After a couple of seconds, we can check the output address
```bash
cardano-cli query utxo --address $address $TESTNET
```

and should see something like this (fictional example):

```bash
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
d82e82776b3588c1a2c75245a20a9703f971145d1ca9fba4ad11f50803a43190     0        999824071 lovelace + 10000000 45fb072eb2d45b8be940c13d1f235fa5a8263fc8ebe8c1af5194ea9c.5365636F6E6454657374746F6B656E + 10000000 45fb072eb2d45b8be940c13d1f235fa5a8263fc8ebe8c1af5194ea9c.54657374746F6B656E
```

## Sending token to a wallet

To send tokens to a wallet, we need to build another transaction - this time only without the minting parameter.
We will set up our variables accordingly.

```bash
fee="0"
receiver="Insert wallet address here"
receiver_output="10000000"
txhash=""
txix=""
funds="Amount of lovelace"
```

Again - here is an example of how it would look if we use our fictional example:

```bash
$ fee="0"
$ receiver="addr_test1qp0al5v8mvwv9mzn77ls0tev3t838yp9ghvgxf9t5qa4sqlua2ywcygl3d356c34576elq5mcacg88gaevceyc5tulwsmk7s8v"
$ receiver_output="10000000"
$ utxoin="d82e82776b3588c1a2c75245a20a9703f971145d1ca9fba4ad11f50803a43190#0"
$ funds="999824071"
```

You should still have access to the other variables from the minting process.
Please check if those variables are set:

```bash
echo Tokenname 1: $tokenname1
echo Address: $address
echo Policy ID: $policyid
```

We will be sending 2 of our first tokens, `Testtoken`, to the foreign address.  
A few things worth pointing out:

1. We are forced to send at least a minimum of 1 ada (1000000 Lovelace) to the foreign address. We can not send tokens only. So we need to factor this value into our output. We will reference the output value of the remote address with the variable receiver_output.
2. Apart from the receiving address, we also need to set our own address as an additional output. Since we don't want to send everything we have to the remote address, we're going to use our own address to receive everything else coming from the input.
3. Our own address, therefore, needs to receive our funds, subtracted by the transaction fee as well as the minimum of 1 ada we need to send to the other address and
4. all of the tokens the txhash currently holds, subtracted by the tokens we send.

:::note Depending on the size and amount of native assets you are going to send it might be possible to send more than the minimum requirement of only 1 ada. For this guide, we will be sending 10 ada to be on the safe side.
Check the [Cardano ledger docs for further reading](https://cardano-ledger.readthedocs.io/en/latest/explanations/min-utxo-alonzo.html#example-min-ada-value-calculations-and-current-constants)
:::

Since we will send 2 of our token to the remote address we are left with 999998 of the `Testtoken`

Here’s what the `raw` transaction looks like:

```bash
cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $utxoin  \
--tx-out $receiver+$receiver_output+"2 $policyid.$tokenname1"  \
--tx-out $address+$output+"9999998 $policyid.$tokenname1"  \
--out-file rec_matx.raw
```

Again we are going to calculate the fee and save it in a variable.

```bash
fee=$(cardano-cli transaction calculate-min-fee --tx-body-file rec_matx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 $TESTNET --protocol-params-file protocol.json | cut -d " " -f1)
```

As stated above, we need to calculate the leftovers that will get sent back to our address.
The logic being:
`TxHash Amount` — `fee` — `min Send 10 ada in Lovelace` = `the output for our own address`

```bash
output=$(expr $funds - $fee - 10000000)
```

Let’s update the transaction:

```bash
cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $utxoin  \
--tx-out $receiver+$receiver_output+"2 $policyid.$tokenname1"  \
--tx-out $address+$output+"9999998 $policyid.$tokenname1"  \
--out-file rec_matx.raw
```

Sign it:
```bash
cardano-cli transaction sign --signing-key-file payment.skey $TESTNET --tx-body-file rec_matx.raw --out-file rec_matx.signed
```

Send it:
```bash
cardano-cli transaction submit --tx-file rec_matx.signed $TESTNET
```

After a few seconds, you, the receiver, should have your tokens. For this example, a Daedalus testnet wallet is used.

![img](../../static/img/nfts/daedalus_tokens_rec.PNG)


## Burning token

In the last part of our token lifecycle, we will burn 5000 of our newly made tokens <i>TestToken</i>, thereby destroying them permanently.

You won't be surprised that this — again — will be done with a transaction.
If you've followed this guide up to this point, you should be familiar with the process, so let's start over.

Set everything up and check our address:

```bash
cardano-cli query utxo --address $address $TESTNET
```

:::note Since we've already sent tokens away, we need to adjust the amount of Testtoken we are going to send.
:::

Let's set our variables accordingly (if not already set). Variables like address and the token names should also be set.

```bash
utxoin="insert your txhash here"
funds="insert Amount only in here"
burnfee="0"
policyid=$(cat policy/policyID)
burnoutput="0"
```

Burning tokens is fairly straightforward.
You will issue a new minting action, but this time with a <b>negative</b> input. This will essentially subtract the amount of token.

```bash
cardano-cli transaction build-raw \
 --fee $burnfee \
 --tx-in $utxoin \
 --tx-out $address+$burnoutput+"9994998 $policyid.$tokenname1"  \
 --mint="-5000 $policyid.$tokenname1" \
 --minting-script-file policy/policy.script \
 --out-file burning.raw
 ```
 

:::note Since we already have multiple transaction files, we will give this transaction a better name and call it <i>burning.raw</i>.
We also need to specify the amount of tokens left after destroying.
The math is:
<i>amount of input token</i> — <i>amount of destroyed token</i> = <i>amount of output token</i>
:::

As usual, we need to calculate the fee. 
To make a better differentiation, we named the variable <i>burnfee</i>:

```bash
burnfee=$(cardano-cli transaction calculate-min-fee --tx-body-file burning.raw --tx-in-count 1 --tx-out-count 1 --witness-count 2 $TESTNET --protocol-params-file protocol.json | cut -d " " -f1)
```

Calculate the correct output value
```bash
burnoutput=$(expr $funds - $burnfee)
```

Re-build the transaction with the correct amounts

```bash
cardano-cli transaction build-raw \
 --fee $burnfee \
 --tx-in $utxoin \
 --tx-out $address+$burnoutput+"9994998 $policyid.$tokenname1"  \
 --mint="-5000 $policyid.$tokenname1" \
 --minting-script-file policy/policy.script \
 --out-file burning.raw
 ```

 Sign the transaction:

 ```bash
 cardano-cli transaction sign  \
--signing-key-file payment.skey  \
--signing-key-file policy/policy.skey  \
$TESTNET  \
--tx-body-file burning.raw  \
--out-file burning.signed
```

Send it:

```bash
cardano-cli transaction submit --tx-file burning.signed $TESTNET
```

Check your address: 

```bash
cardano-cli query utxo --address $address $TESTNET
```

You should now have 5000 tokens less than before:
```bash
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
f56e2800b7b5980de6a57ebade086a54aaf0457ec517e13012571b712cf53fb3     1        989643170 lovelace + 9995000 45fb072eb2d45b8be940c13d1f235fa5a8263fc8ebe8c1af5194ea9c.5365636F6E6454657374746F6B656E
```


### Bonus thought exercise : Have some fun scratching your brain on this one!
Why is it that you need to encode the asset name into hex after cardano-cli version 1.31.0 ?

Have fun trying to answer this one! Hint: It has something to do with unicode!

