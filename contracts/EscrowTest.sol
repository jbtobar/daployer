pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol';

contract EscrowTest  is IERC721Receiver {

  constructor() public {
  }


  function () payable external {}

  function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
      return this.onERC721Received.selector;
  }
}
