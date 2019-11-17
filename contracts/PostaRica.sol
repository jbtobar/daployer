// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './TheERC20Token.sol';



/*
@TODO: be able to remove admins
*/
contract PayWall is ERC721Full, ERC721Mintable, Ownable {

  TheERC20Token USDP;

  uint256 public items = 0;

  mapping(uint256 => mapping(address => bool)) public readers;
  mapping(uint256 => uint256) public prices;
  mapping(uint256 => address) public publishers;

  constructor(address _addressT)
  public
    ERC721Full('FLOWSPOT', 'FLOW')
  {
    USDP = TheERC20Token(_addressT);
  }

  function createPost(bytes12 _id, address _creator, uint256 _price) public returns(uint256) {
    uint _postNumber = items+1;
    prices[_postNumber] = _price;
    publishers[_postNumber] = _creator;
    _mint(_creator, _postNumber);
    items+=1;
    return _postNumber;
  }
  function setPrice(uint256 _id, uint256 _price) public returns(bool) {
    require(msg.sender == publishers[_id]);
    prices[_id] = _price;
    return true;
  }

  function hasAccess(uint256 _id, address _address) public view returns (bool) {
    return readers[_id][_address];
  }


  // function hasAccess(uint256 _id, address _address) returns (bool) {
  //   return readers[_id][_address];
  // }
  function getAccess(uint256 _id)
    public
    returns(bool)
  {
    uint256 ticketPrice = prices[_id];
    address ticketPublisher = publishers[_id];
    if (ticketPrice == 0) return true;
    require(USDP.allowance(address(msg.sender),address(this)) >= ticketPrice);
    require(USDP.balanceOf(msg.sender) >= ticketPrice);
    require(USDP.transferFrom(msg.sender,ticketPublisher,ticketPrice));
    readers[_id][msg.sender] = true;
    return true;
  }
}
