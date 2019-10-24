// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol
/*
 - it maps
*/
contract Users is ERC721Full, ERC721Mintable, Ownable {

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }
  mapping(uint => mapping(bytes32 => Multihash)) public entries;

  mapping(address => bool) public admins;

  modifier onlyAdmin() {
    require(admins[msg.sender] == true);
    _;
  }

  constructor() ERC721Full("FlandesAuto", "FLDS") public {
    admins[msg.sender] = true;
  }

  // usernameCheck
  bytes32[] private usernames;
  mapping(bytes32 => uint) private usernameToId;
  mapping(uint => uint) private passwords;

  function mintMyUser(string memory _username) public {

    bytes32 _usernameBytes = stringToBytes32(_username);
    uint _usernameId = usernames.push(_usernameBytes) - 1;

    usernameToId[_usernameBytes] = _usernameId;

    _mint(msg.sender, _usernameId);
  }

  function setPassword(string memory _username, uint _passcode)
  public
  {
    bytes32 _usernameBytes = stringToBytes32(_username);
    uint id = usernameToId[_usernameBytes];
    require(admins[msg.sender] == true || msg.sender == ownerOf(id));
    passwords[id] = _passcode;
  }

  function setEntry(string memory _username, bytes32 _entryKey, bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    bytes32 _usernameBytes = stringToBytes32(_username);
    uint id = usernameToId[_usernameBytes];
    require(admins[msg.sender] == true || msg.sender == ownerOf(id));
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    entries[id][_entryKey] = entry;
  }

  function getEntry(string memory _username, bytes32 _entryKey, uint _passcode)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    bytes32 _usernameBytes = stringToBytes32(_username);
    uint id = usernameToId[_usernameBytes];

    Multihash storage entry = entries[id][_entryKey];
    require(passwords[id] == _passcode);
    return (entry.digest, entry.hashFunction, entry.size);
  }
  function stringToBytes32(string memory source) public pure returns (bytes32 result)  {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }
    assembly {
      result := mload(add(source, 32))
    }
  }



}
