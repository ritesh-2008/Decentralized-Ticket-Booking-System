// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ownable.sol";

contract wallet is Ownable {
 
 uint public eth = 0.001 ether;
 uint public seats = 100;

   

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
        require(seats > 0);
        seats -=1;
        
        details.push(Ticket({
            name:_name,
            email: _email,
            phoneNo:_phoneNo,
            ticketNo:100 - seats
            }));

    }

    function withdraw() external onlyOwner {
      (bool sent,) =  payable(owner()).call{value: address(this).balance}("");
      require(sent,"error:fail to send ether");
   }
} 