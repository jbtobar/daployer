const fs = require('fs');
buildContractsFolder = './build/contracts/'

module.exports =  function(app, web3) {

    // app.get('/api', (req, res) => {
    //   routes = [
    //     {url:'ui',type:'GET', description:'GET a list of available contracts', href:true},
    //     {url:'ui/abi/[contractName]',type:'GET', description:'Get the abi of a specific contract (contracts available are in previous route)', href:false},
    //   ]
    //   res.render('reference',{user: "Great User",title:"homepage", goods: routes});
    // })
    app.get('/api/v2/contracts', (req, res) => {
        console.log('GET: /api/v2/contracts')
	var file_list = new Array()
	fs.readdir(buildContractsFolder, (err, files) => {
            files.forEach(file => {
                file_list.push(file.split('.')[0])
            });
            res.json({user: "Great User",title:"homepage", goods: file_list});
        })
    })

    app.get('/api/ui', (req, res) => {
      console.log('GET: /api/ui')
      var file_list = new Array()
      fs.readdir(buildContractsFolder, (err, files) => {
        files.forEach(file => {
          file_list.push(file.split('.')[0])
        });
        res.render('ui',{user: "Great User",title:"homepage", goods: file_list});
      })
    })

    app.get('/api/ui/abi/:contractName', (req, res) => {
      var contractName = req.params.contractName
      var bld = require('../../build/contracts/'+contractName+'.json')
      res.setHeader('Content-Type', 'application/json')
      res.status(200).send(JSON.stringify(bld.abi, null, 3));
    })

    app.get('/api/json/:contractName', (req, res) => {
        console.log('/api/json/:contractName')
        var contractName = req.params.contractName
        var bld = require('../../build/contracts/'+contractName+'.json')
        bld.abi.forEach((d) => {if ( d.type == 'constructor' ) { ctr = d }})
        console.log(ctr.inputs)
        buser = ctr.inputs
        res.status(200).json({ contractName: contractName, goods: buser, contractBuild: bld });
    })

    app.get('/api/ui/:contractName', (req, res) => {
      console.log('/api/ui/:contractName')
      var contractName = req.params.contractName
      var bld = require('../../build/contracts/'+contractName+'.json')
      bld.abi.forEach((d) => {if (d.type == 'constructor'){ctr = d}})
      console.log(ctr.inputs)
      buser = ctr.inputs
      res.render('index',{user: "User",title:"apiDeploy", goods: buser, contractName:contractName,contractBuild:bld});
    })

    app.get('/api/json/interact/:contractName', (req, res) => {
        var contractName = req.params.contractName
        var bld = require('../../build/contracts/'+contractName+'.json')
        fxns = []
        bld.abi.forEach(function(d){if (d.type == 'function') {fxns.push(d)}})
        res.status(200).json({ contractName: contractName, goods: fxns, contractBuild: bld });
    })

    app.get('/api/ui/interact/:contractName', (req, res) => {
      var contractName = req.params.contractName
      var bld = require('../../build/contracts/'+contractName+'.json')
      fxns = []
      bld.abi.forEach(function(d){if (d.type == 'function') {fxns.push(d)}})
      res.render('interact',{user: "Great User",title:"homepage", goods: fxns, contractName:contractName, contractBuild:bld});
    })

    app.get('/api/abi/:contractName', (req, res) => {
      var contractName = req.params.contractName
      console.log(contractName)
      bldICO = require('../../build/contracts/'+contractName+'.json')
      let abiICO = bldICO.abi
      res.setHeader('Content-Type', 'application/json')
      res.status(200).send(JSON.stringify(abiICO, null, 3));
    })

}
