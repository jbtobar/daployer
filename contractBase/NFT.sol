pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract MyNFT is ERC721Full, ERC721Mintable {

  string public constant name = "GradientToken";
  string public constant symbol = "GRAD";

  struct Gradient {
    string outer;
    string inner;
  }

  Gradient[] public gradients;

  constructor() ERC721Full("MyNFT", "MNFT") public {
  }

  function getGradient( uint _gradientId ) public view returns(string outer, string inner){
    Gradient memory _grad = gradients[_gradientId];

    outer = _grad.outer;
    inner = _grad.inner;
  }

  function mint(string _outer, string _inner) public payable onlyOwner{
    Gradient memory _gradient = Gradient({ outer: _outer, inner: _inner });
    uint _gradientId = gradients.push(_gradient) - 1;

    _mint(msg.sender, _gradientId);
  }


}