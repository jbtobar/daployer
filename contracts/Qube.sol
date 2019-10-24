// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol
/*
@TODO: be able to remove admins
*/
contract Qube is ERC721Full, ERC721Mintable,Ownable {
  bool public q001 = true;


  struct QubeItem {
    string content;
    bool isPublic;
    mapping(address => bool) whitelist;
  }
  uint public numberOfQubes;
  QubeItem[] private qubes;

  event Minted(address indexed to, uint256 indexed tokenId, bool _isPublic);
  constructor() ERC721Full("QubeToken", "QUBE") public {
  }
  function mintQube(string memory _content, bool _isPublic) public payable  {
    uint _qubeId = numberOfQubes++;
    qubes[_qubeId] = QubeItem(_content, _isPublic);
    _mint(msg.sender, _qubeId);
    emit Minted(msg.sender, _qubeId, _isPublic);
  }
  function setWhitelist(uint _qubeId, address[] memory _whitelist, bool _permission) public {
    require(ownerOf(_qubeId) == msg.sender);
    for (uint256 i = 0; i < _whitelist.length; i++) {
      qubes[_qubeId].whitelist[_whitelist[i]] = _permission;
    }
  }



  function getContent( uint _qubeId ) public view returns(string memory _content) {
    // QubeItem storage _qubeItem = qubes[_qubeId];
    if (qubes[_qubeId].isPublic != true) {
      require(qubes[_qubeId].whitelist[msg.sender] == true);
    }
    _content = qubes[_qubeId].content;
  }
  // function isPublic( uint _qubeId ) public view returns(bool _isPublic) {
  //   // QubeItem storage _qubeItem = qubes[_qubeId];
  //   // if (_qubeItem.isPublic != true) {
  //   //   require(_qubeItem.whitelist[msg.sender] == true);
  //   // }
  //   _isPublic = qubes[_qubeId];
  // }

  // function mintQube() {
  //   _qubeId = numberOfQubes++;
  //   campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
  // }


}
