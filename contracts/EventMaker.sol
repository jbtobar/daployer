pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract EventMaker is ERC721Full, ERC721Mintable, Ownable {

  bool public v06 = true;

  ERC20 USDP;

  uint256 public numTickets;
  uint256 public ticketPrice;
  uint256 public ticketsSold = 0;

  constructor(
      string memory _name,
      string memory _symbol,
      uint256 _numTickets,
      uint256 _ticketPrice
    )
    ERC721Full(_name, _symbol)
    public
  {
    numTickets = _numTickets;
    ticketPrice = _ticketPrice;
    USDP = ERC20(0x965f231C071254A6745E05314f34F832691feeBF);
  }


  function buyTicket()
    public
  {
    require(USDP.transferFrom(msg.sender,address(this),ticketPrice));
    uint _ticketNumber = ticketsSold+1;
    _mint(msg.sender, _ticketNumber);
    ticketsSold+=1;
  }

}
