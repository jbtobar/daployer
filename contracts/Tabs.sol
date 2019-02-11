pragma solidity ^0.5.0;

contract Tabs {

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  mapping(uint => Multihash[]) private entries;

  mapping(uint => mapping(uint => address[])) public signatures;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  function setEntry(uint _gradientId, bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    uint entryID = entries[_gradientId].push(entry);
    signatures[_gradientId][entryID].push(msg.sender);
    emit EntrySet(
      _gradientId,
      _digest,
      _hashFunction,
      _size
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
