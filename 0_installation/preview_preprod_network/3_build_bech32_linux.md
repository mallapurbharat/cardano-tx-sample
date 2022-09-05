## NOTE: The bech32 tool is used to disassemble / assemble cardano addresses from the hex to bech32 encoded addresses or vice-versa

Run the following set of commands at the terminal to build the bech32 executable.

```
cd ~/cardano-src
git clone https://github.com/input-output-hk/bech32.git
cd bech32/
cabal build all
```
### At this point it will show the build output path at the last step as below...
```
[2 of 2] Compiling Main             ( app/Main.hs, /home/bharat/cardano-src/bech32/dist-newstyle/build/x86_64-linux/ghc-8.10.7/bech32-1.1.2/x/bech32/build/bech32/bech32-tmp/Main.o )
Linking /home/bharat/cardano-src/bech32/dist-newstyle/build/x86_64-linux/ghc-8.10.7/bech32-1.1.2/x/bech32/build/bech32/bech32 ...

```

In the case of linux it will be built at the above path. 
Just copy the file bech32 at the above path to the ~/cardano-node-1.35.3-linux directory 

```
cp ~/cardano-src/bech32/dist-newstyle/build/x86_64-linux/ghc-8.10.7/bech32-1.1.2/x/bech32/build/bech32/bech32 ~/cardano-node-1.35.3-linux/
```
To test the bech32 executable, run the below command
```
cd ~/cardano-node-1.35.3-linux/
./bech32 --version

1.1.2
```

to test it's functionality, try the below command

```
bech32 <<< addr_test1qq6akcrjga7dd60h6svq705merqj5rr84dsrxm2gf97xdl7nemt3d4aqtgftld0y8mc07k96d8jwvfm8agp2f7sfkxhs848jmd

0035db6072477cd6e9f7d4180f3e9bc8c12a0c67ab60336d48497c66ffd3ced716d7a05a12bfb5e43ef0ff58ba69e4e62767ea02a4fa09b1af
```
