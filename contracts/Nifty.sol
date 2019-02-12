// pragma solidity ^0.4.24;
pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

//https://github.com/saurfang/ipfs-multihash-on-solidity/blob/master/contracts/IPFSStorage.sol
/*
@TODO: be able to remove admins
*/
contract Nifty is ERC721Full, ERC721Mintable,Ownable {

  bool public v02 = true;

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  /*
  status 0 - registrado, sin comprador
  status 1 - propiedad en escrow - sin placa
  status 2 - propiedad de comprador
  */
  struct Auto {
    // string chasis;
    bytes17 chasis;
    string placa;
    uint8 status;
    bytes32 color;
  }

  Auto[] public autos;
  mapping(bytes17 => uint) public vins;
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

  event Minted(address indexed to, uint256 indexed tokenId, bytes17 chasis, bytes32 color);

  constructor() ERC721Full("FlandesAuto", "FLDS") public {
    admins[msg.sender] = true;
  }

  function getGradient( uint _autoId ) public view returns(bytes17 chasis, string memory placa, uint status, bytes32 color) {
    Auto memory _auto = autos[_autoId];

    chasis = _auto.chasis;
    placa = _auto.placa;
    status = _auto.status;
    color = _auto.color;
  }

  /*
   * @WARNING: ownership make sure with onlyAdmin
   */
  function mintit(bytes17 _chasis, string memory _placa, uint8 _status, string memory _color) public payable  {
    bytes32 _colorBytes = stringToBytes32(_color);
    Auto memory _auto = Auto({ chasis: _chasis, placa: _placa, status: _status, color: _colorBytes });
    uint _autoId = autos.push(_auto) - 1;

    vins[_chasis] = _autoId;

    _mint(msg.sender, _autoId);
    emit Minted(msg.sender, _autoId, _chasis, _colorBytes);
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

  /*
   * @WARNING: ownership make sure with onlyOwner
   */

  function changeColor(uint _autoId, bytes32 _color) public onlyAdmin {
    autos[_autoId].color = _color;
  }
  function tokensOfOwner(address owner) public view returns(uint256[] memory) {
    return _tokensOfOwner(owner);
  }

  function transferToEscrow( address _to, uint256 _tokenId) public {
    safeTransferFrom(msg.sender, _to, _tokenId);
    autos[_tokenId].status = 1;
  }
  function addPlate(uint _autoId, string memory _placa) public onlyAdmin {
    autos[_autoId].placa = _placa;
  }
  function transferFromEscrowToOwner(address _from, address _to, uint256 _tokenId) public {
    safeTransferFrom(_from, _to, _tokenId);
    autos[_tokenId].status = 2;
  }

  // function carByVin(bytes17 memory _chasis) {
  //
  // }


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
