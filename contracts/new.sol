// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ownable.sol";

contract wallet is Ownable {
 
 uint public eth = 0.001 ether;
 uint public ethforvip = 0.004 ether;
 uint public seats = 100;
 uint  public vipseats = 50;
 uint256 public  eventDate;

 
 mapping (address => uint) public usertoTicket;
 mapping (address => uint) public usertoVipTicket;

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
    Ticket[] public vipdetails;

    function payforticket(string memory _name,
       string memory _email,
       uint _phoneNo) payable public {
        require(msg.value == eth, "you have to pay exact amount of eth");
        require(seats > 0,"seats are full");
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

     
    
    // vip tickets
   function Buyvipseats(string memory _name,
       string  memory _email,
       uint _phoneNo)  payable public {
        require(msg.value == ethforvip, "you have to pay exact amount of eth");
        require( vipseats > 0,"seats are full");
        require(usertoVipTicket[msg.sender] == 0,"you alredy own ticket");

      vipseats -=1;
        uint VipTicketNo = vipseats - 50;

        vipdetails.push(Ticket({
          name:_name,
          email:_email,
          phoneNo:_phoneNo,
          ticketNo:VipTicketNo
        }));
        usertoVipTicket[msg.sender] = VipTicketNo;
        emit PurchasedTicket(msg.sender,VipTicketNo , eth);
   }
  //  refund feature for vip
    function refundforvip() external {
    uint ticketno = usertoVipTicket[msg.sender];

      require(block.timestamp < eventDate, "refund period is over");
      require(ticketno > 0,"you dont own Ticket");
      
      usertoVipTicket[msg.sender] = 0;
      vipseats+=1;
  
     (bool sent,) = payable(msg.sender).call{value:ethforvip}("");
      require(sent,"error:issue with refund");
      emit Refund(msg.sender, ticketno, ethforvip);
   }

    //  withdraw the eth
      function withdraw() external onlyOwner {
      uint amount = address(this).balance;
      (bool sent,) =  payable(owner()).call{value: amount}("");
      require(sent,"error:fail to withdraw ether");
      emit Withdraw(owner(),amount);
   }
} 