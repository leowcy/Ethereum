 (async function() {
    
    const Web3 = require('web3');
    
    const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
    
    const isListening = await web3.eth.net.isListening();

    console.log(isListening);

    const jsonfile = require('jsonfile');
    
    const file = './build/contracts/Phonebookbyname.json'
 
    const abii = jsonfile.readFileSync(file).abi;

    const myContract = new web3.eth.Contract(abii, '0xf2b7c0FdFcF85a971605E359B49aE946f8d251e7');

    //Add person to phone book
    let resultofadd = await myContract.methods.AddToPhonebook("Ariel", "002", "654321")
        .send({from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });

    console.log(resultofadd);

    //Get person info on the phone book
    let resultofget = await myContract.methods.GetInfobyName("Ariel").send({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });
    
    console.log(resultofget);

    //Delete info by Name
    let resultofdel = await myContract.methods.DeleteInfobyName("Ariel").send({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });
    
    console.log(resultofdel);

    //Peoplecount
    const resultcall = await myContract.methods.Peoplecount().call({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });

    console.log(resultcall);

})()

