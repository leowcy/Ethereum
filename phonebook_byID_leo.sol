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
    
    //function to check value in the array
    function checkposition(uint[100] memory c, uint d) private pure returns(uint){
        uint f1 = 0;
        for(uint j = 0; j<c.length; j++){
            if(d == c[j]){
                f1 = j; //has the same value, return true
            }
        }
        return f1;
    }
    
    //Add person to phonebook
    function AddToPhonebook(uint pId, string memory name_, uint phonenum_) public returns(string memory){
        
        if(check(idofpeople, pId)){
            return ("This ID already exist. Please choose others.");
        }   else    {
            idofpeople[flagofidofpeople] = pId;
            flagofidofpeople++;
            people[pId].name = name_;
            people[pId].phonenum = phonenum_;
            peoplecount++;
            return("OK. Successfully add.");
        }
    }
    
    //Find person by Id
    function GetInfobyId(uint pId) public returns (string memory, uint) {
        
        //if exist this ID
        if(check(idofpeople, pId)){
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
            }   else    {
                return ("Not exist this ID of person. Pleack check.", 0);
        }
    } 
    
    //delete the person by Id on the phonebook
    function DeleteInfobyId(uint pId) public returns(string memory){
        if(!check(idofpeople,pId)){
            return ("Not exist this ID. Please check.");
        }   else    {
            idofpeople[checkposition(idofpeople,pId)] = 9999999999999; //set an not exist value
            delete people[pId].name;
            delete people[pId].phonenum;
            peoplecount--;
            return ("already delete Successfully!");
        }
    }

    //count the number of people on the phonebook
    function Peoplecount() public view returns (uint) {
        return peoplecount;
    }
}
