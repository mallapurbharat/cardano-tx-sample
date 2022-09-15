## IF NOTHING ELSE WORKS (for example on a Mac M1!) you can follow the below steps to run a docker instance of the cardano-node and go on with your exercises as usual

### First download the docker instance

```
docker image pull inputoutput/cardano-node:1.35.3-configs
```

### run the below command at the terminal and let it run continuously without exiting
```
docker run -v /data -e NETWORK=preview inputoutput/cardano-node:1.35.3-configs
```

### now, in A NEW TERMINAL INSTANCE,  find the running container name or id 
```
docker container ls
```

### You might see output like below (note the container name under NAMES)
```console
foo@bar:$ docker container ls

CONTAINER ID   IMAGE                                     COMMAND        CREATED          STATUS          PORTS     NAMES
41b8be9d2b93   inputoutput/cardano-node:1.35.3-configs   "entrypoint"   43 minutes ago   Up 43 minutes             <dreamy_rubin>
```

### use the above container name to launch an interactive terminal with bash
```
docker exec -it <container-name> bash
```

### In the second terminal, run the below command as it is at the prompt _FOR THE FIRST TIME ONLY_
### NOTE: Change the --testnet-magic 2 to --testnet magic 1 for preprod network if required
```
echo -e 'export CARDANO_NODE_SOCKET_PATH="/ipc/node.socket"\nexport TESTNET="--testnet-magic 2"\nalias ctip="cardano-cli query tip $TESTNET"' > .bashrc
```


### now you can run the alias 'ctip' and all other cardano-cli commands comfortably!!

```console
foo@bar:$ ctip

{
    "block": 29479,
    "epoch": 9,
    "era": "Babbage",
    "hash": "47aa9f1fd0aece5346f4540424ca620050817d4efa23b9569b520d422e1e5e3e",
    "slot": 824546,
    "syncProgress": "25.32"
}
```
