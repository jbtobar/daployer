pragma solidity ^0.5.0;

import './Factura.sol';

contract FacturasFactory {

  bool public v02 = true;

  address[] public facturas;
  address public admin;
  uint public facturasLength;
  event FacturaEmitida(address indexed facturaAddress, address indexed buyer, uint indexed tokenId);

  constructor() public {
    admin = msg.sender;
  }


  function newFactura(address _admin, address _facturador,address _niftyAddress, uint _niftyId ,address _buyer, uint _price, uint _months, uint _interes, uint _pagoInicial,address _usdpAddress) public {
    Factura factura = new Factura(_admin, _facturador, _niftyAddress,  _niftyId , _buyer,  _price,  _months,  _interes,  _pagoInicial, _usdpAddress);
    emit FacturaEmitida(address(factura), _buyer, _niftyId);
    facturas.push(address(factura));
    facturasLength+=1;
  }

}
