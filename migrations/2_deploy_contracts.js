var Token = artifacts.require("./Token.sol");

var artifactor = require("truffle-artifactor");

module.exports = function(deployer) {
    deployer.deploy(Token, "DAPloyer", "DPLY",18)
}
