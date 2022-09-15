## I liked the details shared in this guide, saving it for reference

# Cardano Plutus Pioneers Playground Start-up Steps for macOS Intel i7
By: Christophe Garant, Updated: 2022 Jan 23
credit: 
## Computer Specs
- Macbook Pro 2015, macOS Monterey (v12.1), Intel Quad Core i7
- git checkout 41149926c108c71831cfe8d244c83b0ee4bf5c8a (Week of Jan 17 2022)

## Setup & Weekly Workflow for Homework Code
1. Git clone the plutus 1) pioneer program repository 2) plutus and 3) plutus-apps
 repositories (copy the github to your local machine).  

    `git clone https://github.com/input-output-hk/plutus-pioneer-program.git`
    
    `git clone https://github.com/input-output-hk/plutus.git`
    
    `git clone https://github.com/input-output-hk/plutus-apps.git`

2. Checkout the git commit version of the week in `plutus-pioneers-program` by going to the /code/week#/cabal.project file
    - open the cabal.project file of the week
	- look for "https://github.com/input-output-hk/plutus-apps.git"
	- copy git commit tag # (e.g. 41149926c108c71831cfe8d244c83b0ee4bf5c8a for week 1 cohort 3)
	
3. In local terminal, cd to the ~/plutus-apps directory

    `cd ~/plutus-apps`

4. Checkout the latest git version to local

    `git checkout <paste-tag-here>`

    e.g. git checkout 41149926c108c71831cfe8d244c83b0ee4bf5c8a

5. Update and build code with cabal. In ~/plutus-apps directory

    `cabal update`
    
    `cabal build`
    
    _Note: if you don't run cabal build, your playground code won't compile, error will be "module not found"_


## Initial Plutus Playground Build Setup
Using Cohort 3 Week 1 as an example:
- https://github.com/input-output-hk/plutus-pioneer-program/blob/main/code/week01/cabal.project
- git checkout 41149926c108c71831cfe8d244c83b0ee4bf5c8a
- Recommend local directory /Users/<user_name>/code/haskell/plutus-pioneer-program/code/week01
- See References below for credit

1. Install per [Nix documenation for macOS](https://nixos.org/download.html#nix-install-macos)

    `sh <(curl -L https://nixos.org/nix/install)`

    _Note: Most tutorials say to add `--daemon` or `--darwin-use-unencrypted-nix-store-volume`, 
however Nix documentation and others in Cardano Stack Exchange (CSE) claim this is fixed, and not needed._

2. Restart computer

3. Edit `/etc/nix/nix.conf` file by command `sudo nano /etc/nix/nix.conf` to be
    
		build-users-group = nixbld
		
		substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
		trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=volume
		
		sandbox = false
		extra-sandbox-paths = /System/Library/Frameworks /System/Library/PrivateFrameworks /usr/lib /private/tmp /private/var/tmp /usr/bin/env
		experimental-features = nix-command
		extra-experimental-features = flakes
    Ref: (this took a lot of research and investigation to get this right)
    - [CSE: Recommendation to have sandbox=false](https://cardano.stackexchange.com/a/6745/4012)
    - [macOS Monterey i7, what is the best `nix.conf` file to use?](https://cardano.stackexchange.com/questions/6700/macos-monterey-i7-what-is-the-best-nix-conf-file-to-use)
    - [cardano-plutus-apps-install-m1 by ranzwo](https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/README.md)
        - nix.conf file good reference, minus the x86_64 stuff for M1 chip.
        
4. Restart computer

5. Clone plutus-apps and plutus repositories of not already performed.

6. Cd to ~/plutus-apps

7. Check correct git checkout by command `git status`, which should show the tag head -> 
41149926c (already did git checkout of latest)

8. Build the plutus playground server and client (from ~/plutus-apps directory)
		
	`nix-build -A plutus-playground.server -A plutus-playground.client`
	
	_Note: this may take a while the first time (hours)_
		
9. Fire up the nix-shell (first time takes a while).  The nix-shell is the "haskell requirements environment".
		
	`nix-shell`
		
10. Start the plutus server

	`cd plutus-playground-server`
		
	`GC_DONT_GC=1 plutus-playground-server`
		
	_Note: without GC_DONT_GC=1, seems the playground won't compile, will post "error cannot find module"_
	
	_Note2: what is GC_DONT_GC=1? [CSE by @angerman](https://cardano.stackexchange.com/a/6676/4012)_
	
	 > "GC_DONT_GC=1 disables the boehm garbage collector in nix. 
	 > There are edge cases that our nix expressions can hit, which cause nix to segfault."
			
11. Start the plutus client

	In terminal, start new tab (ctrl+t).  Should be in dir ~/plutus-apps still (check by command `pwd`).
		
	`nix-shell`
	
12. Update dependancies npm (java)

	`sudo GC_DONT_GC=1 npm install -g npm`
	
	_Note: Must include GC_DONT_GC=1 
	[CSE: Unable to start /plutus-apps client application](https://cardano.stackexchange.com/questions/6320/unable-to-start-plutus-apps-client-application)_

13. Configure and start localhost in browser

14. Open localhost tab in browser

    [http://localhoust:8009/](http://localhost:8009/)
    
	Note: http not http**s**, https was blocked by proxy firewall

15. Configure localhost config.js file 

	Change directories to plutus, and edit webpack.config.js file
	
	`cd /plutus-apps/plutus-playground-client`
	
	Open `webpack.config.js` in text editor, search for `devServer`, and update the following:
    - https to 'false', host to '0.0.0.0', in API target, make "http" not "https", add extra "timeout" line
	
            module.exports = {
            devtool,
            devServer: {
                contentBase: path.join(__dirname, "dist"),
                compress: true,
                port: 8009,
                host: '0.0.0.0',
                https: false,
                stats: "errors-warnings",
                proxy: {
                    "/api": {
                            target: "http://localhost:8080",
                            timeout: 1000 * 60 * 10
                    },
                },
            },
	
	`Save file`
		
	_Note: This is needed to connect client to server with enough timeout buffer,
	and configure localhost config file such that the playground can run without firewall blocking it, 
	from my understanding._
	
	Ref:
	- Http and localhost edits [CSE: @prodineeritecht comment to Playground client can't connect to playground server (all localhost)](https://cardano.stackexchange.com/a/6329/4012)
	- Add timeout [CSE: @Frank DelPidio comment to Plutus Pioneer Program - Problem with plutus playground client](https://cardano.stackexchange.com/a/1992/4012)

16. start client node server

	`cd plutus-playground-client`
	
	`GC_DONT_GC=1 npm run start`
	
	_Note: before just used `npm run start`, but local host did not show up.  When in doubt, GC_DONT_GC_
		
17. Plutus playground should come up in local host, after advancing thru Safety warnings in browser. 
Compile should work. Cheers.


## Diary of Troubleshooting
Herein is a diary play-by-play of my failed attempts, troubleshooting, 
and blood trail of Cardano Stack Exchange questions opened, as well as help from Plutus Discord.

- Installed Nix using `sh <(curl -L https://nixos.org/nix/install) --daemon`
- Used the following `nix.conf` file

        build-users-group = nixbld
        substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
        trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=volume

- Built the Nix by `GC_DONT_GC=1 nix-build -A plutus-playground.client -A plutus-playground.server`
- Ran the configuration/requirements shell by `CG_DONT_GC=1 nix-shell`

**Issues encountered**
- After running nix-shell in ~/plutus-apps, ran check on nix by `nix doctor --verbose`. Had the following error.

        Running checks against store uri: daemon
        [FAIL] Multiple versions of nix found in PATH:
            /nix/store/iq3ra93h9kxmnrw3zlxmqn8ng5w62dra-nix-2.5.1/bin
            /nix/store/j6fqvmsfhl4frzqn2f3bzhn8hr16j5q5-nix-2.5.1/bin
  			
 - Proceed to run the `nix-build` again, ran all night, timed out or froze.  
    - Read comment here that https://cardano.stackexchange.com/questions/3878/sandbox-error-when-running-nix-build
    - Remove the sanbox and extra-sandbox-paths from nix/conf file
 
- Nix-build worked, but then nix-shell had the following error:
 
        error: getting status of /nix/var/nix/daemon-socket/socket: Operation not permitted

- Solution was to totally uninstall Nix and start fresh, and fix the nix.conf file
    - Ref [CSE: nix doctor --verbose [FAIL] Multiple versions of nix found in PATH, on MacOS i7](https://cardano.stackexchange.com/questions/6648/nix-doctor-verbose-fail-multiple-versions-of-nix-found-in-path-on-macos-i7)
    - Ref [CSE: Sandbox error when running nix build on macOS](https://cardano.stackexchange.com/a/6745/4012)

**How to Uninstall Nix**
- See [CSE solution to nix doctor --verbose [FAIL] Multiple versions of nix found in PATH, on MacOS i7](https://cardano.stackexchange.com/a/6706/4012)
    - Run script from [Github: kintsugi/uninstall-nix-osx.sh](https://gist.github.com/kintsugi/47e5e9f9d7c3a3a2f6004b6271365f8c)
    - AND/OR follow [Github: @zimbatm comment on issue](https://github.com/NixOS/nix/issues/1402#issuecomment-312496360)
    - RESTART COMPUTER
    - In terminal, ~/plutus-apps directory, `nix doctor --verbose`. Should be 3 passes.
    

## Nix helpful commands
| command | notes |
| :---- | :---- |
| nix doctor --verbose			 	         | precheck |
| nix --version					             | to check it is installed correctly |
| nix-channel --update --verbose	       	 |seems to not work|
| nix-env -iA nixpkgs.nix-update	       	 |works, command for non NixOS|
| nix-build --show-trace			         |to get details of fails|
| nix-collect-garbage			             |cleans up garbage old files https://www.mankier.com/1/nix-collect-garbage|
| --extra-experimental-features nix-command  |some commands are 'experimental' and need this flag set|


## References, Resources, and Credit

1. [CSE, macOS Monterey i7, what is the best `nix.conf` file to use?, Garant](https://cardano.stackexchange.com/questions/6700/macos-monterey-i7-what-is-the-best-nix-conf-file-to-use)
    - For macOS i7 
2. [cardano-plutus-apps-install-m1 by @renzwo](https://github.com/renzwo/cardano-plutus-apps-install-m1/blob/main/README.md)
    - For masOS M1, but good notes besides the nix.conf file extra stuff for M1.  Yarn install didn't work for me.
    
3. [MacOS Setup for Plutus Pioneer Program by @Til-D](https://github.com/Til-D/cardano-plutus)
	- macOS i7, probably the most useful tutorial reference.
	
4. [Plutus developer environment setup on MacOS Monterey by @Punkbit](https://www.punkbit.com/hacking/plutus-developer-environment-setup-on-macos-monterey/)
	- the `yarn install` did not work for me, the npm did. 
	
5. [Cardano Stack Exchange - Plutus Pioneers Program](https://cardano.stackexchange.com/questions/tagged/plutus-pioneer-program)

6. [Nix Documentation](https://nixos.org/manual/nix/stable/introduction.html)


## Contact Info
- github: [ccgarant](https://github.com/ccgarant)
- twitter: [@TheStophe](https://twitter.com/TheStophe)
- discord: ccgarant#8489
- cardano stack exchange: [ccgarant](https://cardano.stackexchange.com/users/4012/ccgarant) 
- Bitcoin & Cardano, since 2017; Ergo since 2020
- Plutus Pioneers Program, Cohort 3 (Jan 2022)
