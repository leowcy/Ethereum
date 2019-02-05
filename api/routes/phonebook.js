const express = require('express');
const router = express.Router();
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
const jsonfile = require('jsonfile');
const file = '/home/leo/solidity/phonebookbyname/build/contracts/Phonebookbyname.json';
const abii = jsonfile.readFileSync(file).abi;
const myContract = new web3.eth.Contract(abii, '0x232AD0cCcEa833CDF24A9c785C00fEc805Ef581F');

//get person
router.get('/', (req, res, next) =>{
    res.status(200).json({
        message: 'Welcome to my /phonebook'
    });
});

//Add person
router.post('/', async (req, res, next) =>{

    const person = {
        name: req.body.name,
        id: req.body.id,
        phonenumber: req.body.phonenumber
    };

    await myContract.methods.AddToPhonebook(person.name, person.id, person.phonenumber).send({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1',
    });

    res.status(201).json({
        message: 'Add Person to phone book successfully.',
        createdPerson: {
            name: person.name,
            id: person.id,
            phonenumber: person.phonenumber,
            request: {
                type: 'POST',
                url: "http://localhost:8080/phonebook/"+person.name
            }
        }
    });
});

//get value
router.get('/:phonebookname', async(req, res, next) =>{

    const name = req.params.phonebookname;

    await myContract.methods.GetInfobyName(name).send({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });

    const result = await myContract.methods.ViewInfo().call({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });
    
    //people count
    if(name === 'peoplecount'){
        const number = await myContract.methods.Peoplecount().call({
            from: '0xb346145433a3004a2de208478c49bf290e7866ab',
            gas: '9040000',
            gasPrice: '1'
        });
        res.status(200).json({
            message: 'People numbers count:' + number
        })        
    }   else    {
        res.status(201).json({
            message: "Outcome...",
            result: result
        });
    }
});

router.delete('/:phonebookname', async (req, res, next) =>{
    await myContract.methods.DeleteInfobyName(req.params.phonebookname).send({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });
    const result = await myContract.methods.ViewDelete().call({
        from: '0xb346145433a3004a2de208478c49bf290e7866ab',
        gas: '9040000',
        gasPrice: '1'
    });
    res.status(200).json({
        message: 'Outcome...',
        result: result
    });
});

module.exports = router;
