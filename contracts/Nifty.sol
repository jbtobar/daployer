// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol

contract Nifty is ERC721Full, ERC721Mintable,Ownable {

  uint public v01;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  struct Gradient {
    string chasis;
    string placa;
  }

  Gradient[] public gradients;
  mapping(uint => Multihash) private entries;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  event Minted(address indexed to, uint256 indexed tokenId, string chasis);

  constructor() ERC721Full("FlandesAuto", "FLDS") public {
  }

  function getGradient( uint _gradientId ) public view returns(string memory chasis, string memory placa){
    Gradient memory _grad = gradients[_gradientId];

    chasis = _grad.chasis;
    placa = _grad.placa;
  }

  /*
   * @WARNING: ownership make sure with onlyOwner
   */
  function mintit(string memory _chasis, string memory _placa) public payable {
    Gradient memory _gradient = Gradient({ chasis: _chasis, placa: _placa });
    uint _gradientId = gradients.push(_gradient) - 1;

    _mint(msg.sender, _gradientId);
    emit Minted(msg.sender, _gradientId, _chasis);
  }

  /*
   * @WARNING: ownership make sure with onlyOwner
   */
  function addPlate(uint _gradientId, string memory _placa) public {
    // Gradient memory _grad = gradients[_gradientId];
    gradients[_gradientId].placa = _placa;
  }

  function tokensOfOwner(address owner) public view returns(uint256[] memory) {
    return _tokensOfOwner(owner);
  }


  /**
   * @dev associate a multihash entry with the sender address
   * @param _digest hash digest produced by hashing content using hash function
   * @param _hashFunction hashFunction code for the hash function used
   * @param _size length of the digest
   */
  function setEntry(uint _gradientId, bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    entries[_gradientId] = entry;
    emit EntrySet(
      _gradientId,
      _digest,
      _hashFunction,
      _size
    );
  }

  /**
   * @dev retrieve multihash entry associated with an address
   * @param _gradientId uint used as key
   */
  function getEntry(uint _gradientId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_gradientId];
    return (entry.digest, entry.hashFunction, entry.size);
  }

}

