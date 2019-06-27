// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol
/*
@TODO: be able to remove admins
*/
contract Quber is ERC721Full, ERC721Mintable, Ownable {

  bool public v05 = true;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }
  Multihash[] public entries;
  mapping(bytes32 => bool) public digestChecker;

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
    require(digestChecker[_digest] != true);
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);

    uint _contractId = entries.push(entry) - 1;

    _mint(msg.sender, _contractId);
    emit EntrySet(
      _contractId,
      _digest,
      _hashFunction,
      _size
    );
    digestChecker[_digest] = true;
    // emit Minted(msg.sender, _contractId, _chasis, _colorBytes);
  }
  function qubeIt(address _to, bytes32 _digest, uint8 _hashFunction, uint8 _size) public payable onlyMinter {
    require(digestChecker[_digest] != true);
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);

    uint _qubeId = entries.push(entry) - 1;

    _mint(_to, _qubeId);
    emit EntrySet(
      _qubeId,
      _digest,
      _hashFunction,
      _size
    );
    digestChecker[_digest] = true;
  }

  function getEntry(uint _contractId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_contractId];
    return (entry.digest, entry.hashFunction, entry.size);
  }

}
