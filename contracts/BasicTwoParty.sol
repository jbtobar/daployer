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
  event EntrySigned (
    uint indexed key,
    bool partyOne,
    bool partyTwo
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

    function createSignedEntry(
      address _partyTwo,
      bytes32 _digest,
      uint8 _hashFunction,
      uint8 _size
    )
      public
    {
      Entry memory entry = Entry(msg.sender,_partyTwo,_digest,_hashFunction,_size,true,false);
      entries[counter+1] = entry;
      counter += 1;

      EntrySet(
        counter,
        _digest,
        _hashFunction,
        _size
      );
      emit EntrySigned(counter,true,false);
    }

    function sign(uint _counter)
    public
    {
      if (entries[_counter].partyOne === msg.sender) {
        require(entries[_counter].partyOneSigned !== true);
        entries[_counter].partyOneSigned = true;

        emit EntrySigned(_counter,true,entries[_counter].partyTwoSigned);
      } else {
        require(entries[_counter].partyTwo === msg.sender);
        require(entries[_counter].partyTwoSigned !== true);
        entries[_counter].partyTwoSigned = true;

        emit EntrySigned(_counter,entries[_counter].partyOneSigned,true);
      }
    }



}
