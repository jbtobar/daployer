pragma solidity ^0.5.0;

import './Factura.sol';

contract FacturasFactory {

  bool public v02 = true;

  address[] public facturas;
  event FacturaEmitida(address indexed facturaAddress, address indexed buyer, uint indexed tokenId);


  function newFactura(address _niftyAddress, uint _niftyId ,address _buyer, uint _price, uint _months, uint _interes, uint _pagoInicial,address _usdpAddress) public {
    Factura factura = new Factura( _niftyAddress,  _niftyId , _buyer,  _price,  _months,  _interes,  _pagoInicial, _usdpAddress);
    emit FacturaEmitida(address(factura), _buyer, _niftyId);
    facturas.push(address(factura));
  }

}
