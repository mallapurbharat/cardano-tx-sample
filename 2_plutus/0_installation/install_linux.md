## Step by Step Guide on Installation of Plutus Playground on Ubuntu/Linux systems


1.Recommended machine config: Ubuntu 20.10 / 20.04 installed
Native boot will work faster for all the below steps. Everything stays the same whether it's a VM or a native boot Ubuntu

2. Execute:
```    
        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install snap git nano curl
```
 
## Install Nix 

4. Execute
```    
        curl -L https://nixos.org/nix/install > install-nix.sh
        chmod +x install-nix.sh
        ./install-nix.sh
        . ~/.nix-profile/etc/profile.d/nix.sh
```

5.	verify installations with --version
Execute
```
        nix --version
        git --version
        nano --version
```

6. IOHK Binary Cache (necesary for saving hours of time in the Plutus Libraries installation)

Execute:
```
    sudo mkdir -p /etc/nix
    sudo nano /etc/nix/nix.conf
```
Include on the open file this:
```    
substituters = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=

```
(Reference: In nano editor, You can Save with Ctrl-O and close the file with Ctrl-X)

## SETUP PLUTUS-APPS

7.Clone the Plutus-Apps repository
Execute
```
    git clone https://github.com/input-output-hk/plutus-apps.git
    cd plutus-apps/
    git checkout 41149926c108c71831cfe8d244c83b0ee4bf5c8a (This dependency is referenced in the code/week01/cabal.project file)
```

8. Now, Launch the nix-shell
```
        nix-shell
        cabal update
```
## NOW INSTALL AND RUN THE PLUTUS PLAYGROUND
9. In the same window change the directory by executing

```
        cd plutus-playground-server
        cabal update
        plutus-playground-server
```

Takes a while and ends with the text:
```
    Interpreter ready 
```  
  
10. Open a *new* terminal (on the GUI or a new SSH connection if no gui)

11. Change into the plutus-apps and open nix
Execute
```

    cd plutus-apps/
    nix-shell
```    
    
12. Change into plutus-playground-client folder, update and start
```
        cd plutus-playground-client
        cabal update
        npm start
```
You might use a browser to navigate to https://localhost:8009 and be able to see the Plutus Application Playground, try compiling and running the test contract to see if you were successfull.


## Building the Plutus Documentation 


Navigate to the plutus-apps folder and open another nix-shell 
Execute
 ```   
    build-and-serve-docs
```
This will build the plutus documentation. 
Once it is running, open up your browser and navigate to http://0.0.0.0:8002/haddock. If this site doesn't work, navigate to http://localhost:8002/haddock

