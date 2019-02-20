// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol
/*
@TODO: be able to remove admins
*/
contract Signer is ERC721Full, ERC721Mintable,Ownable {

  bool public v03 = true;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }
  Multihash[] public entries;
  mapping(uint => address[]) public signatures;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  // event Minted(address indexed to, uint256 indexed tokenId, bytes17 chasis, bytes32 color);

  constructor() ERC721Full("FlandesAuto", "FLDS") public {
    
  }

  function mintit( bytes32 _digest, uint8 _hashFunction, uint8 _size) public payable  {
    // bytes32 _colorBytes = stringToBytes32(_color);
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);

    uint _contractId = entries.push(entry) - 1;
    signatures[_contractId].push(msg.sender);

    _mint(msg.sender, _contractId);
    emit EntrySet(
      _contractId,
      _digest,
      _hashFunction,
      _size
    );
    // emit Minted(msg.sender, _contractId, _chasis, _colorBytes);
  }

  function sign(uint _contractId) public {
    signatures[_contractId].push(msg.sender);
  }

  // function getContract(uint _contractId)
  // public
  // view
  // returns(bytes32 digest, uint8 hashfunction, uint8 size)
  // {
  //   Multihash storage entry = entries[_contractId];
  //   return (entry.digest, entry.hashFunction, entry.size);
  // }

  function getEntry(uint _contractId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_contractId];
    return (entry.digest, entry.hashFunction, entry.size);
  }

}
