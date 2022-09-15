## IF NOTHING ELSE WORKS (for example on a Mac M1!) you can follow the below steps to run a docker instance of the cardano-node ON THE PREVIEW NETWORK and go on with your exercises as usual

### First download the docker instance

```
docker image pull inputoutput/cardano-node:1.35.3-configs
```

### Create local cardano-node-data and cardano-node-ipc volumes:
```
docker volume create cardano-node-data
docker volume create cardano-node-ipc
```

### run the below command at the terminal and let it run continuously without exiting
### What we are configuring:
- naming the container as cardano-node
- mounting a folder /home/bharat/testnet/exercises which we can use to create various exercise files in our host and map them into the docker container to run them (**change the folder to your particular folder**)
- launching the preview network (other option is preprod)
- storing all data in cardano-node-data volume
- creating the IPC node socket in cardano-node-ipc volume
    
```
docker run --name cardano-node --mount type=bind,source="/home/bharat/testnet/exercises/",target=/exercises -e NETWORK=preview -v cardano-node-ipc:/ipc -v cardano-node-data:/data inputoutput/cardano-node:1.35.3-configs
```

### Copy a basic .bashrc file (_use the .bashrc file in the same github path_)  to the docker container to configure our bash shell with some comforts

```
docker cp ./.bashrc cardano-node:/.bashrc
```

### use the above container name (cardano-node ) to launch an interactive terminal with bash
```
docker exec -it cardano-node bash
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

Congratulations! You now have a running cardano-node on ANY SYSTEM!

### NOTE: You may see some messages like below (esp. when the node is fully synced and no new blocks are coming in for a short time)

```console
[9c30af41:cardano.node.ConnectionManager:Info:2019] [2022-09-15 19:14:23.80 UTC] TrConnectionManagerCounters (ConnectionManagerCounters {fullDuplexConns = 0, duplexConns = 2, unidirectionalConns = 0, inboundConns = 0, outboundConns = 2})
[9c30af41:cardano.node.ConnectionManager:Info:2019] [2022-09-15 19:14:24.03 UTC] TrConnectError (Just 0.0.0.0:3001) 89.58.43.194:19000 Network.Socket.connect: <socket: 51>: does not exist (Connection refused)
[9c30af41:cardano.node.ConnectionManager:Info:2019] [2022-09-15 19:14:24.03 UTC] TrConnectionManagerCounters (ConnectionManagerCounters {fullDuplexConns = 0, duplexConns = 2, unidirectionalConns = 0, inboundConns = 0, outboundConns = 2})
[9c30af41:cardano.node.PeerSelection:Info:54] [2022-09-15 19:14:24.03 UTC] TracePromoteColdFailed 50 2 89.58.43.194:19000 160.607736456222s Network.Socket.connect: <socket: 51>: does not exist (Connection refused)
[9c30af41:cardano.node.ChainDB:Notice:33] [2022-09-15 19:15:01.73 UTC] Chain extended, new tip: a2716eeb33f6a6f3a9892b9298958489c9318dbdb81f18340f7d86c56652d752 at slot 3266101
[9c30af41:cardano.node.ChainDB:Notice:33] [2022-09-15 19:15:14.79 UTC] Chain extended, new tip: 063631994657365e3d324b25e68fd342761122f2f6ec24ba8e6b655cc8e6daeb at slot 3266114
[9c30af41:cardano.node.ChainDB:Notice:33] [2022-09-15 19:15:25.75 UTC] Chain extended, new tip: e075e0a9391c3ca0bcacd9443a3abd93d28817ff965964f56c1b5244c9aeaa56 at slot 3266125
```

Typically you might see some errors like 
   **Network.Socket.connect: <socket: 51>: does not exist (Connection refused)**. 
   **Network.Socket.connect: <socket: 31>: does not exist (No route to host)**
   **Network.Socket.connect: <socket: 45>: timeout (Connection timed out)**

But as long as the ctip command **shows some progress in the slots every minute or so**, you are still connected to the network and good to go!


### NOTE: In case you face any troubles with the docker containers, you might need to clean them and reinstall again cleanly using the above steps.
First exit the docker cardano-node instance by hitting CTRL+C

```
docker stop cardano-node
docker rm cardano-node
docker volume rm  cardano-node-data cardano-node-ipc
docker rmi inputoutput/cardano-node:1.35.3-configs
```


