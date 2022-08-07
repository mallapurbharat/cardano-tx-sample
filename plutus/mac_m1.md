source: https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/README.md

# cardano-plutus-apps-install-m1

some useful infos:
https://cardano.stackexchange.com/questions/6287/lessons-learned-setting-up-plutus-playground-feedback-welcome

https://docs.plutus-community.com/docs/setup/MacOS.html (do not use the "plutus" repo! instead use "plutus-apps")

For Intel Macs: https://github.com/Til-D/cardano-plutus

And finalised thanks to @nrkramer Nolan Kramer!

## It might be a good idea to uninstall any existing Nix installation just to ensure that we don't face any issues due to old installations

Refer https://nixos.org/manual/nix/stable/installation/installing-binary.html#macos for how to do this

## Step by step

1 download the nix package manager and install it
```
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```
2 restart terminal

3 open the nix config file
```console
sudo nano /etc/nix/nix.conf
```
4 be sure these lines are all inside the file
```
build-users-group = nixbld

substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=

system = x86_64-darwin
extra-platforms = x86_64-darwin aarch64-darwin

sandbox = false
extra-sandbox-paths = /System/Library/Frameworks /System/Library/PrivateFrameworks /usr/lib /private/tmp /private/var/tmp /usr/bin/env
experimental-features = nix-command
extra-experimental-features = flakes

```
5 restart mac

6 clone the right repository! not the ...plutus one, it needs to be the ...plutus-apps repo:
```
git clone https://github.com/input-output-hk/plutus-apps
```
7 goto folder
```
cd plutus-apps/
```
8 no checkout of commits needed, just use the master branch for now

9 build the server
```
nix-build -A plutus-playground.server

```
IMPORTANT: if there occurs a segfault, just build it again, it will work.

10 build the client
```
nix-build -A plutus-playground.client
```
same here, if there are errors during build, just call the command again.

11 start nix shell (takes some time)
```
nix-shell
```
12 goto server dir and start server (yes, with the GC thing in front)
```
cd plutus-playground-server
GC_DONT_GC=1 plutus-playground-server
```
sometimes the server will not start at first try. try again, second start should work!

13 wait until server is started! you will see something like this
```
plutus-playground-server: for development use only
[Info] Running: (Nothing,Webserver {_port = 8080, _maxInterpretationTime = 80s})
Initializing Context
Initializing Context
Warning: GITHUB_CLIENT_ID not set
Warning: GITHUB_CLIENT_SECRET not set
Warning: JWT_SIGNATURE not set
Interpreter ready
```
14 when server is started you can open a second nix-shell in another terminal
```
nix-shell
```
15 in the second terminal with nix-shell run
```
sudo npm install -g npm
```
16 goto client dir and start client (yes, with the GC thing in front)
```
cd plutus-playground-client
GC_DONT_GC=1 npm run start
```
17 wait until client has started and you see something like this
```
webpack compiled with 1 warning
ℹ ｢wdm｣: Compiled with warnings.
```
will take some time. same here as above: if there are errors be sure to try at least a second build!

if the client takes to long it could be that it runs in timeout which is default 80 seconds.

to prevent this and change the timeout to 150 seconds eg, you can start the server with an option like this:
```
GC_DONT_GC=1 plutus-playground-server -i 150s
```


both should work now, client with https cert security warning in your browser: https://localhost:8009/

wanna fix the certificate error in your browser? in plutus-playground-client folder do
```
nano webpack.config.js
```
and change the "https" flag from "true" to "false".

thats it, but not needed. the url from now on would be http://localhost:8009



to make some space on your harddrive without deleting nix - if you do not use nix for a while:

https://www.reddit.com/r/NixOS/comments/mndp6a/garbage_collection/

https://nixos.org/guides/nix-pills/garbage-collector.html


or to uninstall nix, maybe you want to reinstall after macOS update?

Use https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/uninstall-nix-osx.sh 

Do a "chmod 777 uninstall-nix-osx.sh" before using it with "sudo".
