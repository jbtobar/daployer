// require('dotenv').config()
const express        = require('express');
const bodyParser     = require('body-parser');
if (process.argv[2] == 'live') {
    rpcUrl = 'http://0.0.0.0/rpc/'
} else {
    rpcUrl = 'http://165.227.96.86/rpc/'
}
if (process.argv[2] == 'localhost') {
    rpcUrl = 'http://localhost:8545'
}

console.log(process.argv[2])
var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider(rpcUrl));
console.log('Provider Endpoint at: ' + rpcUrl)

const app            = express();
const port = 3001;

var accounts;
web3.eth.getAccounts().then(e => {
    accounts = e;
    console.log(accounts)
})

app.set("view engine", "ejs");

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    next();
});


app.use(bodyParser.urlencoded({ extended: true }));


app.use(bodyParser.json())

// require('./app/routes')(app, {});
require('./app/routes')(app, web3);


app.listen(port, () => {
    console.log('We are live on ' + port);
});
