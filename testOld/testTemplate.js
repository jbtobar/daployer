// import assertRevert from "zeppelin-solidity/test/helpers/assertRevert";
// import { getBytes32FromMultiash, getMultihashFromContractResponse } from '../src/multihash';
// const multihash = require('../src/multihash')
// getBytes32FromMultiash = multihash.getBytes32FromMultiash
// getMultihashFromContractResponse = multihash.getMultihashFromContractResponse

const Users = artifacts.require("Users");


contract("Users", accounts => {

  var user1 = accounts[0]
  var user2 = accounts[1]
  var user3 = accounts[2]
  var user4 = accounts[3]
  var user5 = accounts[4]
  var user6 = accounts[5]
  var user7 = accounts[6]
  var user8 = accounts[7]
  var user9 = accounts[8]
  var user10 = accounts[9]

  it("User makes a token with a username", async () => {});

  it("Another user cannot make a token with that username", async () => {});


});



/*
 - An NFT token with vehicle VIN and IPFS-HASH is minted by FLANDES and assigned to ESCROW address
 - When NF


   it("creates car token", async () => {
     token = await instance.mintit("1N4BA41E94C895344", "");
   })
   it("verifies current car token owner", async () => {
     current_owner = await instance.ownerOf(0)
     console.log(current_owner)
   })
   it("creates Escrow contract", async () => {
     var args = [
       instance.address,0,buyer1,price, 0
     ]
     escrow = await Escrow.new(...args,{from:flandes})
   })
   it("assigns ownership of car token to escrow contract", async () => {
     current_owner = await instance.ownerOf(0)
     await instance.safeTransferFrom(current_owner,escrow.address,0,{from:current_owner});
   })
   it("verifies current car token owner", async () => {
     current_owner = await instance.ownerOf(0)
     console.log(current_owner)
   })
   it("buyer transfer price to escrow", async () => {
     await web3.eth.sendTransaction({
       from:buyer1,
       to:escrow.address,
       value:price
     })
   })
   it("buyer calls paid method", async () => {
     await escrow.paid({from:buyer1})
   })
   it("verifies current car token owner", async () => {
     current_owner = await instance.ownerOf(0)
     console.log(current_owner)
   })























*/
