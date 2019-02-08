// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol

contract Nifty is ERC721Full, ERC721Mintable,Ownable {

  bool public v02 = true;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  struct Auto {
    string chasis;
    string placa;
  }

  Auto[] public autos;
  mapping(uint => Multihash) private entries;

  mapping(address => bool) public admins;

  modifier onlyAdmin() {
    require(admins[msg.sender] == true);
    _;
  }

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  event Minted(address indexed to, uint256 indexed tokenId, string chasis);

  constructor() ERC721Full("FlandesAuto", "FLDS") public {
    admins[msg.sender] = true;
  }

  function getGradient( uint _autoId ) public view returns(string memory chasis, string memory placa){
    Auto memory _auto = autos[_autoId];

    chasis = _auto.chasis;
    placa = _auto.placa;
  }

  /*
   * @WARNING: ownership make sure with onlyAdmin
   */
  function mintit(string memory _chasis, string memory _placa) public payable  {
    Auto memory _auto = Auto({ chasis: _chasis, placa: _placa });
    uint _autoId = autos.push(_auto) - 1;

    _mint(msg.sender, _autoId);
    emit Minted(msg.sender, _autoId, _chasis);
  }

  /*
   * @WARNING: ownership make sure with onlyOwner
   */
  function addPlate(uint _autoId, string memory _placa) public onlyAdmin {
    autos[_autoId].placa = _placa;
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
  function setEntry(uint _autoId, bytes32 _digest, uint8 _hashFunction, uint8 _size)

  public
  {
    require(admins[msg.sender] == true || msg.sender == ownerOf(_autoId));
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    entries[_autoId] = entry;
    emit EntrySet(
      _autoId,
      _digest,
      _hashFunction,
      _size
    );
  }

  /**
   * @dev retrieve multihash entry associated with an address
   * @param _autoId uint used as key
   */
  function getEntry(uint _autoId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_autoId];
    return (entry.digest, entry.hashFunction, entry.size);
  }

}
