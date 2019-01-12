pragma solidity ^0.4.24;

/* struct Multihash {
  bytes32 digest;
  uint8 hashFunction;
  uint8 size;
} */

contract BasicTwoParty {

  struct Entry {
    address partyOne;
    address partyTwo;
    bool partyOneSigned;
    bool partyTwoSigned;
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  mapping(uint => ContractBase) public entries;
  uint public counter = 0;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  constructor() public {

  }

  function createEntry(
      address _partyOne,
      address _partyTwo,
      bytes32 _digest,
      uint8 _hashFunction,
      uint8 _size
    )
    public
    {
      Entry memory entry = Entry(_partyOne,_partyTwo,_digest,_hashFunction,_size,false,false);
      entries[counter+1] = entry;
      counter += 1;

      EntrySet(
        counter,
        _digest,
        _hashFunction,
        _size
      );

    }

    function createSignedEntry() public {}

    function sign() public {}

}
