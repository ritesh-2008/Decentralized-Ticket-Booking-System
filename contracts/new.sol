// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ownable.sol";

contract wallet is Ownable {
 
 uint public eth = 0.001 ether;
 uint public seats = 100;
 uint256 public  eventDate;
 
 mapping (address => uint) public usertoTicket;

  event PurchasedTicket(address indexed buyer,uint ticketno, uint amount);
  event Refund(address indexed user,uint ticketno,uint amount);
  event Withdraw(address indexed withdraweth , uint amount);

    struct Ticket {
       string name;
       string email;
       uint phoneNo;
       uint  ticketNo;
      }

    Ticket[] public details;

    function payforticket(string memory _name,
       string memory _email,
       uint _phoneNo) payable public {
        require(msg.value == eth, "you have to pay exact amount of eth");
        require(seats > 0,"sets are full");
        require(usertoTicket[msg.sender] == 0,"you already own a ticket");
        seats -=1;
        uint TicketNO = 100 - seats;
        
        details.push(Ticket({
            name:_name,
            email: _email,
            phoneNo:_phoneNo,
            ticketNo:TicketNO
            }));
      usertoTicket[msg.sender] = TicketNO;
      emit PurchasedTicket(msg.sender, TicketNO, eth);
    }

    // refund users eth
    constructor(){
      eventDate = block.timestamp + 7 days;
    }
    function refund() external  {
      uint TicketNo = usertoTicket[msg.sender];
      
      require(block.timestamp < eventDate, "refund period is over");
      require(TicketNo > 0,"you dont own Ticket");
      
      usertoTicket[msg.sender] = 0;
      seats +=1;

      (bool sent,) =  payable(msg.sender).call{value: eth}("");
       require(sent,"error:issue with refund");
       
      emit Refund(msg.sender, TicketNo, eth);
    }

      //  withdraw the eth
      function withdraw() external onlyOwner {
      uint amount = address(this).balance;
      (bool sent,) =  payable(owner()).call{value: amount}("");
      require(sent,"error:fail to withdraw ether");
      emit Withdraw(owner(),amount);
   }

} 