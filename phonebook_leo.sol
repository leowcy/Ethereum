pragma solidity ^0.5.3;

contract phonebook_leo {
    
    //Person struct definition
    struct Person {
        string name;
        uint phonenum;
        string add;
    }    
    
    //count the times of using GetInfobyId function
    uint flag = 0;
    
    //count the number of people on the phonebook
    uint peoplecount = 0;
    
    //map function
    mapping(uint => Person) people;
    
    //Add person to phonebook
    function AddToPhonebook(uint pId, string memory name_, uint phonenum_) public {
        
        people[pId].name = name_;
        people[pId].phonenum = phonenum_;
        peoplecount++;
    }
    
    //Find person by Id
    function GetInfobyId(uint pId) public returns (string memory, uint)  {
        
        string memory res = "You exceeded the times using this function.";
        //only can search 3 times
        if(flag < 3){
            flag++;
            return (people[pId].name, people[pId].phonenum);
        }   else    {
            return (res, 404);
        }
    } 
    
    //delete the person by Id on the phonebook
    function DeleteInfobyId(uint pId) public {
        delete people[pId].name;
        delete people[pId].phonenum;
        peoplecount--;
    }

    //You can only GetInfobyId 3 times. Once exceed, you have to use this function to reset
    //and then you can gain another 3 times to use GetInfobyId()
    function reset() public returns (uint){
        return flag = 0;
    }
    
    //count the number of people on the phonebook
    function Peoplecount() public view returns (uint) {
        return peoplecount;
    }

    
}