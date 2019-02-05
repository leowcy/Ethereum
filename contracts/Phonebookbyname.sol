pragma solidity >=0.4.21 <0.6.0;

contract Phonebookbyname{
    
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
    
    //An array to store ID in case of duplicate
    string[100] nameofpeople;
    uint[100] idofpeople;
    uint flagofpeople = 0;

    //For ViewInfo function Output
    string outA = "";
    uint outB = 0;
    uint outC = 0;
    //For ViewDelete function
    string outD = "";

    //map function
    mapping(string => Person) people;
    
    //function to check Name  
    function CheckName(string[100] memory a, string memory b) private pure returns (bool) {
        bool f = false;
        for(uint i = 0; i<a.length; i++){
            if(uint(keccak256(abi.encodePacked(a[i]))) == uint(keccak256(abi.encodePacked(b)))){
                f = true; //has the same value, return true
            }
        }
        return f;
    }

    //check ID. Both name and ID cannot be the same with history.
    function CheckId(uint[100] memory a, uint b) private pure returns (bool) {
        bool f = false;
        for(uint i = 0; i<a.length; i++){
            if(b == a[i]){
                f = true; //has the same value, return true
            }
        }
        return f;
    }
    
    //find position in the array
    function CheckPosition(string[100] memory c, string memory d) private pure returns (uint) {
        uint f1 = 0;
        for(uint j = 0; j<c.length; j++){
            if(uint(keccak256(abi.encodePacked(c[j]))) == uint(keccak256(abi.encodePacked(d)))){
                f1 = j; //has the same value, return the position in the array
            }
        }
        return f1;
    }


    //Add person to phonebook
    function AddToPhonebook(string memory name, uint id_, uint phonenum_) public returns (string memory) {
        
        if(CheckName(nameofpeople, name) || CheckId(idofpeople, id_)){
            outD = "Already exist this Username or Id. Choose make a new one";
            return "Already exist this Username or Id. Choose make a new one";
        }   else    {
            nameofpeople[flagofpeople] = name;
            idofpeople[flagofpeople] = id_;
            flagofpeople++;
            people[name].id = id_;
            people[name].phonenum = phonenum_;
            peoplecount++;
            outD = "OK. Successfully add."; 
            return "OK. Successfully add.";
        }
    }
    
    //Find person by Id
    function GetInfobyName(string memory name) public returns (string memory, uint, uint) {
        if(CheckName(nameofpeople, name) && CheckId(idofpeople, people[name].id)){
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
                outA = err;
                return (err, 0, 0);
            } else { //request less or equal to 3 time, we can return the value
                outA = name;
                outB = people[name].id;
                outC = people[name].phonenum;
                return ("ok", people[name].id, people[name].phonenum);
            } 
            }  else    { //not found the record
            outA = "Not found";
            outB = 404;
            outC = 404;
            return ("Not found.", 404, 404);
        }
    } 
    
    function ViewInfo() public view returns (string memory, uint, uint) {
        return (outA, outB, outC);
    }

    //delete the person by Id on the phonebook
    function DeleteInfobyName(string memory name) public returns (string memory) {
        if(CheckName(nameofpeople, name) && CheckId(idofpeople, people[name].id)){
            nameofpeople[CheckPosition(nameofpeople, name)] = "";
            idofpeople[CheckPosition(nameofpeople, name)] = 999999999999999999999999999;
            delete people[name];
            peoplecount--; 
            outD = "Successfully delete!";
            return "Successfully delete!";
        }   else    {
            outD = "Not exist. Fail to delete. Please check.";
            return "Not exist. Fail to delete. Please check.";
        }
    }
    //ViewDelete
    function ViewDelete() public view returns (string memory) {
        return outD;
    }

    //count the number of people on the phonebook
    function Peoplecount() public view returns (uint) {
        return peoplecount;
    }
}
