pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

import './TheERC20Token.sol';

contract EventMakerWithERC20 is ERC721Full, ERC721Mintable, Ownable {

  bool public v06 = true;

  TheERC20Token USDP;

  uint256 public numTickets;
  uint256 public ticketPrice;
  uint256 public ticketsSold = 0;
  address public tokenAddress;

  constructor(
      string memory _name,
      string memory _symbol,
      uint256 _numTickets,
      uint256 _ticketPrice,
      address _tokenAddress
    )
    ERC721Full(_name, _symbol)
    public
  {
    numTickets = _numTickets;
    ticketPrice = _ticketPrice;
    USDP = TheERC20Token(_tokenAddress);
    tokenAddress = _tokenAddress;
  }

  function redeemFunds() public onlyOwner {
    uint256 _balance = USDP.balanceOf(address(this));
    require(USDP.transfer(owner(),_balance));
  }


  function buyTicket()
    public
    returns(bool)
  {
    // USDP.transferFrom(msg.sender,address(this),0);
    require(ticketsSold<numTickets);
    require(USDP.allowance(address(msg.sender),address(this)) > ticketPrice);
    require(USDP.balanceOf(msg.sender) > ticketPrice);
    require(USDP.transferFrom(msg.sender,address(this),ticketPrice));
    // USDP.transferFrom(msg.sender,address(this),ticketPrice);
    uint _ticketNumber = ticketsSold+1;
    _mint(msg.sender, _ticketNumber);
    ticketsSold+=1;
    return true;
  }

}
