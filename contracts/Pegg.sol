pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract Pegg is ERC20Mintable, ERC20Detailed, ERC20Burnable {
  bool public p1 = true;
  constructor(string memory _name,string memory _symbol,uint8 _decimals) ERC20Detailed(_name, _symbol,_decimals) public {
  }
}
