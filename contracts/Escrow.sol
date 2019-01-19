pragma solidity ^0.5.0;

import './Nifty.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol';

contract Escrow  is IERC721Receiver {

  address public niftyAddress;
  uint public niftyId;
  address public buyer;
  address payable admin;
  uint public price;

  uint public duration;
  uint public startDate;

  modifier onlyFlandes() {
    require(msg.sender == admin);
    _;
  }

  constructor(address _niftyAddress, uint _niftyId ,address _buyer, uint _price, uint _duration) public {
    admin = msg.sender;
    niftyAddress = _niftyAddress;
    niftyId = _niftyId;
    buyer = _buyer;
    price = _price;
    duration = _duration;
    startDate = now;
  }

  function paid() public {
    require(address(this).balance >= price);
    Nifty nifty = Nifty(niftyAddress);
    // require(nifty.safeTransferFrom(address(this),buyer,niftyId));
    nifty.safeTransferFrom(address(this),buyer,niftyId);
    // require(admin.transfer(address(this).balance));
    admin.transfer(address(this).balance);
  }

  function kill() public {
    // require(now - startDate >= 30 days);
    Nifty nifty = Nifty(niftyAddress);
    // require(nifty.transferFrom(address(this),admin,niftyId));
    nifty.safeTransferFrom(address(this),admin,niftyId);
  }

  function safeSwitch() public onlyFlandes {
    Nifty nifty = Nifty(niftyAddress);
    // require(nifty.safeTransferFrom(address(this),admin,niftyId));
    nifty.safeTransferFrom(address(this),admin,niftyId);
    // require(admin.transfer(address(this).balance));
    admin.transfer(address(this).balance);
  }

  function () payable external {}

  function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
      return this.onERC721Received.selector;
  }
}
