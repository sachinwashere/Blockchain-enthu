// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;


contract EventContract {
	struct Event{
		address organizer;
		string name;
		uint date;
		uint price;
		uint ticketCount;
		uint ticketRemain;
	}
	mapping(uint=>Event) public events;
	mapping(address=>mapping(uint=>uint)) public tickets;
	uint public nextId;
	
	function createEvent(string memory name, uint date , uint price , uint ticketCount) external {
		require(date>block.timestamp, "You can organize event for future date");
		require(ticketCount>0,"You can organize event only if you create more than 0 tickets");

		events[nextId] = Event(msg.sender , name , date , price , ticketCount , ticketCount);
		nextId++;
	}
	function buyTicket(uint Id , uint quantity) external payable {
	require(events[Id].date!=0,"Event does not exist");
	require(events[Id].date>block.timestamp,"Event has already occured");
	Event storage _event = events[Id];
	require(msg.value==(_event.price*quantity),"Ether is not enough");
	require(_event.ticketRemain>=quantity,"Not enough tickets");
	_event.ticketRemain=quantity;
	tickets[msg.sender][Id]+=quantity;
	}
	function transferTicket(uint Id , uint quantity , address to) external{
     require(events[Id].date!=0,"Event does not exist");
	require(events[Id].date>block.timestamp,"Event has already occured");
	require(tickets[msg.sender][Id]>=quantity,"You don't have enough tickets");
	tickets[msg.sender][Id]-= quantity;
	tickets[to][Id]+=quantity;
	}
}
	

