## Step by Step Guide on Installation of Plutus Playground on Ubuntu/Linux systems


### Tested with machine config: 

    M1 MacBook Pro (13-inch, M1, 2020)
    Chip - Apple M1
    Monterey version of MacOS installed

## Setting up nix and plutus environment

### Install nix NixOS - Getting Nix / NixOS 6

    curl -L https://nixos.org/nix/install | sh

Edit /etc/nix/nix.conf file and add this line from IOHK binary cache

    substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
    trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=

This is only for M1 user, inside /etc/nix/nix.conf add this line (Reference) 6

    # system = aarch64-darwin
    system = x86_64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    
Update the env with running this on terminal 

    nix-env -iA nixpkgs.nix
    
Restart computer (THIS IS IMPORTANT, in order for nix to restart their daemon tools, and source the nix.conf file)


## SETUP PLUTUS-APPS

7.Clone the Plutus-Apps repository
Execute

    git clone https://github.com/input-output-hk/plutus-apps.git
    cd plutus-apps/
    git checkout 41149926c108c71831cfe8d244c83b0ee4bf5c8a (This dependency is referenced in the code/week01/cabal.project file)


8. Now, Launch the nix-shell


         nix-shell
         cabal update

## NOW INSTALL AND RUN THE PLUTUS PLAYGROUND
9. In the same window change the directory by executing


        cd plutus-playground-server
        cabal update
        plutus-playground-server


Takes a while and ends with the text:

    Interpreter ready 
    
  
10. Open a *new* terminal (on the GUI or a new SSH connection if no gui)

11. Change into the plutus-apps and open nix
Execute

    cd plutus-apps/
    nix-shell
    
    
12. Change into plutus-playground-client folder, update and start

        cd plutus-playground-client
        cabal update
        npm start

You might use a browser to navigate to https://localhost:8009 and be able to see the Plutus Application Playground, try compiling and running the test contract to see if you were successfull.


## Building the Plutus Documentation 


Navigate to the plutus-apps folder and open another nix-shell 
Execute
    
    build-and-serve-docs

This will build the plutus documentation. 
Once it is running, open up your browser and navigate to http://0.0.0.0:8002/haddock
