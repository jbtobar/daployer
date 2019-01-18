var Nifty = artifacts.require("./Nifty.sol");

//var artifactor = require("truffle-artifactor");

module.exports = function(deployer) {
    deployer.deploy(Nifty)
}
