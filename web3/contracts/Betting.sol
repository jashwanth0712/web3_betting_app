// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Betting {
    struct Event{
        address Organizer;
        string title;
        string description;
        uint256 maximum_pool;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] betters;
        uint256[] betting_amount;
    }
    mapping(uint256 => Event ) public events;
    uint256 public  numberofEvents = 0;

    function  creatEvent(
        address _Organizer,string memory _title,string memory _description,uint256 _maximum_pool,
        uint256 _deadline,string memory _image
        )
        public returns (uint256){
            // creating a new event 
            Event storage newEvent = events[numberofEvents];
            // checking if is everything is ok
            require (newEvent.deadline < block.timestamp , "The deadline should be a date in future");
            
            newEvent.Organizer= _Organizer;
            newEvent.title= _title;
            newEvent.description= _description;
            newEvent.maximum_pool= _maximum_pool;
            newEvent.deadline= _deadline;
            newEvent.amountCollected= 0;
            newEvent.image= _image;

            numberofEvents++;
            return numberofEvents-1;
        }
    // this is the function where we send crypto and require wallet login 
    function  betInEvent(
        uint256 _id
        )
        public payable {
            //msg contains all the details of the transaction
            uint256 amount = msg.value;
            Event storage currentEvent=events[_id];
            currentEvent.betters.push(msg.sender);
            currentEvent.betting_amount.push(amount);

            (bool sent,)=payable(currentEvent.Organizer).call{value:amount}("");

            if(sent){
                currentEvent.amountCollected += amount;
            }
        }
    //function to get the list of betters , note : its a view function 
    function  getBetters(
        uint256 _id
        )
        view public returns(address[] memory,uint256[] memory){
            return (events[_id].betters,events[_id].betting_amount);
        }
    function  getEvents()
        view public returns(Event[] memory){
            // we create a list of empty structs of size 'number of events'
            Event[] memory AllEvents = new Event[](numberofEvents) ; // [{},{},{}...]
            for(uint i=0;i<numberofEvents;i++){
                Event storage item =events[i];
                AllEvents[i]=item;
            }
            return AllEvents;
        }


}
