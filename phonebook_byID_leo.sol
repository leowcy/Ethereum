pragma solidity ^0.5.3;

contract Phonebook_byID_leo {
    
    //Person struct definition
    struct Person {
        string name;
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
    
    //An array to store ID in case of duplicate
    uint[100] idofpeople;
    uint flagofidofpeople = 0;
    
    //error message afering asking too often
    string err = "You can only GetInfobyId three times in 5 minutes. Please wait.";
    
    //map function
    mapping(uint => Person) people;
    
    //function to check value in the array
    function check(uint[100] memory a, uint b) private pure returns(bool){
        bool f = false;
        for(uint i = 0; i<a.length; i++){
            if(b == a[i]){
                f = true; //has the same value, return true
            }
        }
        return f;
    }
    
    //Add person to phonebook
    function AddToPhonebook(uint pId, string memory name_, uint phonenum_) public returns(string memory){
        
        if(check(idofpeople, pId)){
            return "This ID already exist. Please choose others.";
        }   else    {
            idofpeople[flagofidofpeople] = pId;
            flagofidofpeople++;
            people[pId].name = name_;
            people[pId].phonenum = phonenum_;
            peoplecount++;
            return "OK. Successfully add.";
        }
    }
    
    //Find person by Id
    function GetInfobyId(uint pId) public returns (string memory, uint) {
        
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
            return (err, 500);
        } else { //request less or equal to 3 time, we can return the value
            return (people[pId].name, people[pId].phonenum);
        }
    } 
    
    //delete the person by Id on the phonebook
    function DeleteInfobyId(uint pId) public returns(string memory){
        if(!check(idofpeople,pId)){
            return "Not exist this ID. Please check.";
        }   else    {
            delete people[pId].name;
            delete people[pId].phonenum;
            peoplecount--;
            return "already delete Successfully!";
        }
    }

    //count the number of people on the phonebook
    function Peoplecount() public view returns (uint) {
        return peoplecount;
    }
}

//this Contract still exists bugs. 
//1. delete the same id repetitionally, the Peoplecount() outcome may be differred.
//Solution of 1: we need to get the position of check() function once find the same value. then -
//- go back to the idofpeople array of that position of set the value to 0. Then fix.
//2. Getinfo by ID - if the ID not exist, then call the check() first and we can throw in error message. 
//That will be better.
//3. Time[] and idofpeople[] are only length of 100. Try to learn and use Dynamic array in the future.