// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './TheERC20Token.sol';



/*
@TODO: be able to remove admins
*/
contract PostaRica is ERC721Full, ERC721Mintable, Ownable {

  TheERC20Token USDP;

  uint256 public items = 0;
  address public admin;

  mapping(uint256 => mapping(address => bool)) public readers;
  mapping(uint256 => uint256) public prices;
  mapping(uint256 => address) public publishers;
  mapping(uint256 => bytes12) public postids;
  mapping(bytes12 => uint256) public idsposts;
  mapping(address => uint256) public gains;

  constructor(address _addressT)
  public
    ERC721Full('FLOWSPOT', 'FLOW')
  {
    USDP = TheERC20Token(_addressT);
    admin = msg.sender;
  }

  function createPost(bytes12 _postid, address _creator, uint256 _price) public returns(uint256) {
    uint _postNumber = items+1;
    prices[_postNumber] = _price;
    publishers[_postNumber] = _creator;
    postids[_postNumber] = _postid;
    idsposts[_postid] = _postNumber;
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
  function postidFromToken(uint256 _id) public view returns (bytes12) {
    return postids[_id];
  }
  function tokenFromPostid(bytes12 _postid) public view returns (uint256) {
    return idsposts[_postid];
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
    gains[ticketPublisher] += ticketPrice;
    readers[_id][msg.sender] = true;
    return true;
  }

  function myGains(address _creator) public view returns (uint256) {
    return gains[_creator];
  }
  function withdrawGains() public returns (bool) {
    uint256 _gains = gains[msg.sender];
    require(USDP.transferFrom(address(this),msg.sender,_gains));
    return true;
  }
  function withdrawGainsAdmin(address _creator) public returns (bool) {
    require(msg.sender == admin);
    uint256 _gains = gains[_creator];
    require(USDP.transferFrom(address(this),_creator,_gains));
    return true;
  }
}
