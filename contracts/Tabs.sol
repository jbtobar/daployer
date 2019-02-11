pragma solidity ^0.5.0;

contract Tabs {

  address public admin;

  struct SegLoc {
    uint gradientId;
    uint entryID;
  }
  uint public segLen;
  SegLoc[] public seguros;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  uint public entryLen;
  mapping(uint => Multihash[]) private entries;
  mapping(uint => bytes32[]) public entryKeys;
  mapping(uint => mapping(uint => address[])) public signatures;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size,
    bytes32 entryKey,
    address sender
  );

  constructor() public {
    admin = msg.sender;
  }

  function setEntry(uint _gradientId, bytes32 _entryKey, bool _esSeguro ,bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    uint entryID = entries[_gradientId].push(entry);
    signatures[_gradientId][entryID].push(msg.sender);

    entryKeys[_gradientId].push(_entryKey);
    entryLen+=1;

    if (_esSeguro) {
      seguros.push(SegLoc(_gradientId, _entryId));
      segLen+=1;
    }

    emit EntrySet(
      _gradientId,
      _digest,
      _hashFunction,
      _size,
      _entryKey,
      msg.sender
    );
  }

  function signEntry(uint _gradientId, uint _entryId) public {
    signatures[_gradientId][_entryId].push(msg.sender);
  }

  function getEntry(uint _gradientId, uint _entryId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_gradientId][_entryId];
    return (entry.digest, entry.hashFunction, entry.size);
  }


}




/**
 * @dev associate a multihash entry with the sender address
 * @param _digest hash digest produced by hashing content using hash function
 * @param _hashFunction hashFunction code for the hash function used
 * @param _size length of the digest
 */


/**
 * @dev retrieve multihash entry associated with an address
 * @param _gradientId uint used as key
 */
