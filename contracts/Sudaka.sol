// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol

contract Sudaka is ERC721Full, ERC721Mintable, Ownable {

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

  function mintMe(uint8 _cedula) public {
    _mint(msg.sender, _cedula);
  }


  function setEntry(uint _cedula, bytes32 _entryKey, bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    require(admins[msg.sender] == true || msg.sender == ownerOf(_cedula));
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    entries[_cedula][_entryKey] = entry
  }

  function getEntry(uint _gradientId, bytes32 _entryKey)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_gradientId][_entryKey];
    return (entry.digest, entry.hashFunction, entry.size);
  }




}
