// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./new.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract mintnft is wallet, ERC721{

uint public price = 0.001 ether;
uint public nextprice = 1;

constructor ERC721("eventTicketNft","TKT") {}

    function nft( ) external {
      
      

    } 
}