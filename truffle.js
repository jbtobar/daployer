/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
require('dotenv').config()
var HDWalletProvider = require('truffle-hdwallet-provider')
var mnemonic = process.env.MNEM
//console.log(mnemonic)
module.exports = {
    networks: {
        localtest: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*", // Match any network id
        },
        live: {
            network_id: 1,
            host: "localhost",
            port: 8546   // Different than the default below
        },
	local: {
	     provider: function() {
	         return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545")
	     },
	     network_id: "*"
	}
    }
};
