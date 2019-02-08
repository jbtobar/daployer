pragma solidity ^0.5.0;

import './Nifty.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';

contract Factura is IERC721Receiver {

  bool public v02 = true;

  address public niftyAddress;
  uint public niftyId;
  bytes17 public vin;

  address public buyer;
  address payable admin;
  address public facturador;

  uint public price;
  bool public pagoPorFinanciamiento;
  uint public fechaLimitePagoInicial;
  uint public interes;

  uint public pagoInicial;
  uint public pagoMatriculacion;

  uint public months;
  uint public startDate;

  ERC20Mintable public usdp;
  Nifty public nifty;
  address public usdpAddress;

  uint[] public pagos;
  uint public pagado;
  bool public success;

  bool public matriculacionPagada;


  modifier onlyFlandes() {
    require(msg.sender == admin);
    _;
  }
  modifier onlyBuyer() {
    require(msg.sender == buyer);
    _;
  }
  modifier onlyParties() {
    require(msg.sender == buyer || msg.sender == admin);
    _;
  }

  constructor(address _niftyAddress, uint _niftyId ,address _buyer, uint _price, uint _months, uint _interes, uint _pagoInicial,address _usdpAddress) public {
    admin = msg.sender;
    facturador = msg.sender;
    niftyAddress = _niftyAddress;
    niftyId = _niftyId;
    buyer = _buyer;
    price = _price;
    months = _months;
    startDate = now;
    interes = _interes;
    pagoInicial = _pagoInicial;
    usdpAddress = _usdpAddress;
    usdp = ERC20Mintable(usdpAddress);
    nifty = Nifty(_niftyAddress);
  }

  function ponerPagoMatriculacion(uint _pagoMatriculacion) public onlyFlandes {
    require(!matriculacionPagada);
    pagoMatriculacion = _pagoMatriculacion;
  }

  function pagarMatriculacion() public onlyBuyer {
    require(msg.sender == buyer);
    require(pagoMatriculacion > 0);
    require(nifty.ownerOf(niftyId) == address(this));
    require(usdp.transferFrom(facturador,buyer,pagoMatriculacion));
    matriculacionPagada = true;
  }

  function hacerPago(uint _pago) public onlyBuyer {
    require(matriculacionPagada);
    require(usdp.transferFrom(facturador,buyer,_pago));
    pagos.push(_pago);
    pagado+=_pago;
  }
  function finalizar() public onlyParties {
    nifty.safeTransferFrom(address(this),buyer,niftyId);
    success = true;
  }




  // function transferTokens() private {}

  // function pagado() public {
  //   require(address(this).balance >= price);
  //   Nifty nifty = Nifty(niftyAddress);
  //   // require(nifty.safeTransferFrom(address(this),buyer,niftyId));
  //   nifty.safeTransferFrom(address(this),buyer,niftyId);
  //   // require(admin.transfer(address(this).balance));
  //   admin.transfer(address(this).balance);
  // }
  //
  // function kill() public {
  //   // require(now - startDate >= 30 days);
  //   Nifty nifty = Nifty(niftyAddress);
  //   // require(nifty.transferFrom(address(this),admin,niftyId));
  //   nifty.safeTransferFrom(address(this),admin,niftyId);
  // }
  //
  // function safeSwitch() public onlyFlandes {
  //   Nifty nifty = Nifty(niftyAddress);
  //   // require(nifty.safeTransferFrom(address(this),admin,niftyId));
  //   nifty.safeTransferFrom(address(this),admin,niftyId);
  //   // require(admin.transfer(address(this).balance));
  //   admin.transfer(address(this).balance);
  // }
  //
  // function () payable external {}

  function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
      return this.onERC721Received.selector;
  }
}
