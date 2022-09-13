Source: https://developers.cardano.org/docs/native-tokens/minting-nfts/
---
id: minting-nfts
title: Minting NFTs
sidebar_label: Minting NFTs
description: How to mint NFTs on Cardano. 
image: ../img/og-developer-portal.png
---

<iframe width="100%" height="325" src="https://www.youtube.com/embed/n5x9bvrOHW0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture fullscreen"></iframe>

:::note
There are many ways to realize NFTs with Cardano. However, in this guide, we will concentrate on the most dominant way, to attach storage references of other services like [IPFS](https://ipfs.io/) to our tokens.
:::

## What's the difference?
What is the difference between native assets and NFTs?  
From a technical point of view, NFTs are the same as native assets. But some additional characteristics make a native asset truly an NFT:

1. As the name states - it must be 'non-fungible. This means you need to have unique identifiers or attributes attached to a token to make it distinguishable from others.
2. Most of the time, NFT's should live on the chain forever. Therefore we need some mechanism to ensure an NFT stays unique and can not be duplicated.

### The policyID
Native assets in Cardano feature the following characteristics:
1. An amount/value (how much are there?)
2. A name 
3. A unique `policyID`

Since asset names are not unique and can be easily duplicated, Cardano NFTs need to be identified by the `policyID`.  
This ID is unique and attached permanently to the asset.
The policy ID stems from a policy script that defines characteristics such as who can mint tokens and when those actions can be made.

Many NFT projects make the `policyID` under which the NFTs were minted publicly available, so anyone can differentiate fraudulent/duplicate NFTs from the original tokens.

Some services even offer to register your `policyID` to detect tokens that feature the same attributes as your token but were minted under a different policy.

### Metadata attributes

In addition to the unique `policyID` we can also attach metadata with various attributes to a transaction. 

Here is an example from [nft-maker.io](https://www.nft-maker.io/)

```json
{
  "721": {
    "{policy_id}": {
      "{policy_name}": {
        "name": "<required>",
        "description": "<optional>",
        "sha256": "<required>",
        "type": "<required>",
        "image": "<required>",
        "location": {
          "ipfs": "<required>",
          "https": "<optional>",
          "arweave": "<optional>"
        }
      }
    }
  }
}
```
Metadata helps us to display things like image URIs and stuff that truly makes it an NFT. With this workaround of attaching metadata, third-party platforms like [pool.pm](https://pool.pm/) can easily trace back to the last minting transaction, read the metadata, and query images and attributes accordingly.
The query would look something like this:

1. Get asset name and `policyID`.
2. Look up the latest minting transaction of this asset.
3. Check the metadata for label `721`.
4. Match the asset name and (in this case) the {policy_name}-entry.
5. Query the IPFS hash and all other attributes to the corresponding entry.


:::note
**There is currently no agreed standard as to how an NFT or the metadata is defined.**
However, there is a [Cardano Improvement Proposal](https://github.com/cardano-foundation/CIPs/pull/85) if you want to follow the discussion.
:::

### Time locking

Since NFTs are likely to be traded or sold, they should follow a more strict policy. Most of the time, a value is defined by the (artificial) scarcity of an asset.

You can regulate such factors with  [multi-signature scripts](https://github.com/input-output-hk/cardano-node/blob/c6b574229f76627a058a7e559599d2fc3f40575d/doc/reference/simple-scripts.md).

For this guide, we will choose the following constraints:

1. There should be only one defined signature allowed to mint (or burn) the NFT.
2. The signature will expire in **10000 slots** from now to leave the room if we screw something up.


## Prerequisites
Apart from the same requisites as on the [minting native assets](minting.md) guide, we will additionally need:

1. Obviously, what / how many NFTs you want to make.  
--> We are going to make only one NFT
2. An already populated `metadata.json`  
3. Know how your minting policy should look like.
--> Only one signature allowed (which we will create in this guide)  
--> No further minting or burning of the asset allowed after 10000 slots have passed since the transaction was made
4. Hash if uploaded image to IPFS  
--> We will use this [image](https://gateway.pinata.cloud/ipfs/QmRhTTbUrPYEw3mJGGhQqQST9k86v1DPBiTTWJGKDJsVFw)


Actual steps in nonfungibletoken.md. Please complete the exercise there.
