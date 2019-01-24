pragma solidity ^0.5.3;

contract Phonebook_byName_leo {
    
    //Person struct definition
    struct Person {
        uint id;
        uint phonenum;
    }    
    
    //record the pointer of Time array 
    uint flag = 0; 
    //record the times of Require Time array
    uint timesofGet = 0;
    
    //count the number of people on the phonebook
    uint peoplecount = 0;
    
    //time difference from the 4th times to the first times
    uint timediff = 0;
    //time difference from the 4th times to the sencond times
    uint timediff1 = 0;
    //time difference from the 4rd times to the last times
    uint timediff2 = 0;
    
    //create a length of 100 array to store the Time
    uint[100] time;
    
    //error message afering asking too often
    string err = "You can only GetInfobyName three times in 5 minutes. Please wait.";
    
    //map function
    mapping(string => Person) people;
    
    //Add person to phonebook
    function AddToPhonebook(string memory name, uint id_, uint phonenum_) public {
        
        people[name].id = id_;
        people[name].phonenum = phonenum_;
        peoplecount++;
    }
    
    //Find person by Id
    function GetInfobyName(string memory name) public returns (string memory, uint, uint) {
        
        //store timestamp of calling each GetinfobyId 
        time[flag] = block.timestamp;
        
        //record how many times call GetinfobyId()
        timesofGet++;
        
        //make sure flag-2 exist
        if(flag>2){
            timediff = time[flag] - time[flag-3];
            timediff1 = time[flag] - time[flag-2];
            timediff2 = time[flag] - time[flag-1];
        }  
        
        //flag increment by 1
        flag++;
        
        //time over 300s from 4th and 2nd times
        if(timediff1>300){
            timesofGet = 2;
        }
        
        //time over 300s from 4th and 3rd times
        if(timediff2>300){
            timesofGet = 1;
        }
    
        //Request more than 3 times 
        if(timesofGet>3 && timediff<300){
            flag--;
            return (err, 0, 0);
        } else { //request less or equal to 3 time, we can return the value
            return ("ok", people[name].id, people[name].phonenum);
        }
    } 
    
    //delete the person by Id on the phonebook
    function DeleteInfobyName(string memory name) public {
        delete people[name].id;
        delete people[name].phonenum;
        peoplecount--;
    }

    //count the number of people on the phonebook
    function Peoplecount() public view returns (uint) {
        return peoplecount;
    }
}