pragma solidity ^0.5.0;

contract Mappings {

  struct Matricula {
    address owner;
    string vin;
    string placa;
    string marca;
    string modelo;
    uint ano;
    uint fechaMatricula;
  }

  struct Multihash {
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }
  mapping(uint => Matricula) private matriculas;
  mapping(uint => Multihash[]) private entries;

  event EntrySet (
    uint indexed key,
    bytes32 digest,
    uint8 hashFunction,
    uint8 size
  );

  function setMatricula(uint _gradientId, string memory _vin, string memory _placa, string memory _marca, string memory _modelo, uint _ano, uint _fechaMatricula)
  public
  {
    Matricula memory matri = Matricula(msg.sender, _vin,  _placa,  _marca,  _modelo,  _ano,  _fechaMatricula);
    matriculas[_gradientId] = matri;
  }

  function setEntry(uint _gradientId, bytes32 _digest, uint8 _hashFunction, uint8 _size)
  public
  {
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    entries[_gradientId].push(entry);
    emit EntrySet(
      _gradientId,
      _digest,
      _hashFunction,
      _size
    );
  }

  function getEntry(uint _gradientId, uint _entryId)
  public
  view
  returns(bytes32 digest, uint8 hashfunction, uint8 size)
  {
    Multihash storage entry = entries[_gradientId][_entryId];
    return (entry.digest, entry.hashFunction, entry.size);
  }

  function getMatricula(uint _gradientId)
  public
  view
  returns(address owner, string memory vin, string memory placa, string memory marca, string memory modelo, uint ano, uint fechaMatricula)
  {
    Matricula storage matri = matriculas[_gradientId];
    return (matri.owner, matri.vin, matri.placa, matri.marca, matri.modelo, matri.ano, matri.fechaMatricula);
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
