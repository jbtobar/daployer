# Daployer

---
An Open-Source API and GUI

 - An easy-to-use point-and-click GUI for developers and non-developers to deploy/test/interact with their contracts

 - An intuitive API endpoint to integrate contract with an application

Check it out [live](http://165.227.96.86/api/v1/ui)

Check out the [documentation](https://jbtobar.gitbook.io/api/)

Clone the repo from here or npm, start the service with `npm start` and have your own service to deploy and interact with contracts on the ethereum blockchain!

---

Root URL:
```
http://165.227.96.86/api/v1/ui
```
Documentation:
```
https://jbtobar.gitbook.io/api/
```

### Checklist
- [x] GET Routes for Contract Deployment
- [x] GET Routes for Contract Interaction

Daployer - API and GUI

This service is built with the goal of facilitating internal development as well as interaction with clients.

The idea is that the handling/deployment/interaction of smart contracts and connection to the blockchain is done in a separate infrastructure than the main application.

It is also made to facilitate contract development, testing, and communication with non-developers by providing a GUI to interact/deploy with contracts.

The architecture is specific enough to permit intuitive use, and general enough to accommodate any contract that might be submitted in the future.

This service features the following:

    Seamless integration of new contracts with the main platform

    Easy-to-use graphical user interface that allows any member of the team to deploy and interact with smart contracts via point-and-click. For better communication between contract development and team.

    API endpoint that exposes routes to allow accessing the information necessary to interact/deploy with contracts.

How to use
For smart contract developers:

    Write and compile your solidity files using truffle.

    Find the artifacts of your contract ( located in the./build/contracts directory of your truffle project ) and place them in thedaployer/build/contracts directory within this service.

    Done!

You can now go to GUI URL and play with your contract. (or see API Instructions for how to use the GET Routes)

The current workflow assumes contract development with Truffle, as it uses truffle artifacts which are .json files. If needed, compatibility with .sol files can be added.

Interaction with the blockchain is done via MetaMask. Make sure you have it installed.
For the rest:

    Ask the local solidity developer to write up a smart contract and to put it in daployer/build/contracts directory.

    Done!

You can now go to GUI URL and test the contract yourself! Make sure it does what your developer says it does, play with your contract! (or see API Instructions for how to use the GET Routes)
How it works

This service spins up a Node.js server that reads the  daployer/build/contract directory. When accessing the GUI, the server will list all the contracts in that folder and create routes for each of them. Depending on whether the user wants to deploy or interact with the contract, it will generate the necessary html forms to allow the user to point-and-click. The result of these actions will appear on the console on the GUI. 

Take a look at GUI Instructions for more details.
Private Blockchain

We have a private blockchain with an RPC endpoint running at:

http://165.227.96.86/rpc

Due to long confirmation times on Ropsten/Rinkeby, we can use this for testing.

Note: GUI/API is connected to Private Blockchain.
