pragma solidity ^0.4.21;

contract Temp {
  address owner;
  modifier ownerOnly() {
    if (owner == msg.sender) _;
  }
  struct data {
    uint a;
    uint b;
    uint[] arr;
  }
  
  data d1;
  uint[] arr;
  data[] darr;

  mapping(uint => data[]) map;

  function Temp() public {
    owner = msg.sender;
    d1.a = 255;
    d1.b = 8191;
    d1.arr.length = 12;
    for (uint32 i = 0; i < 12; i++) d1.arr[i] = i;
    arr.length = 10;
    for (i = 0; i < 10; i++) arr[i] = i;
    darr.length = 5;
    for (i = 0; i < 5; i++) {
      darr[i].arr.length = 10;
      for (uint32 j = 0; j < 10; j++) darr[i].arr[j] = j;
    }
  }

  function GetA() public view returns (uint) {
    return d1.a;
  }
  function GetB() public view returns (uint) {
    return d1.b;
  }
  function SetA(uint a) ownerOnly() public {
    d1.a = a;
  }
  function SetB(uint b) ownerOnly() public {
    d1.b = b;
  }

  function Getd1() public view returns (uint, uint) {
    return (d1.a, d1.b);
  }

  function SetArr(uint ind, uint val) ownerOnly() public {
    arr[ind] = val;
  }
  function GetArr(uint ind) public view returns (uint) {
    return arr[ind];
  }

  function SetD1Arr(uint ind, uint val) ownerOnly() public {
    d1.arr[ind] = val;
  }
  function GetD1Arr(uint ind) public view returns (uint d1arrind) {
    d1arrind = d1.arr[ind];
  }

  function SetDarr (uint ind, uint a, uint b, uint arrind, uint arrval) ownerOnly() public {
    data storage dloc = darr[ind];
    dloc.a = a;
    dloc.b = b;
    dloc.arr[arrind] = arrval;
  }

  function GetDarr (uint ind, uint arrind) public view returns (uint, uint, uint) {
    data storage dloc = darr[ind];
    return (dloc.a, dloc.b, dloc.arr[arrind]);
  }

  function GetMapping (uint ind1, uint ind2, uint ind3) public view returns (uint a, uint b, uint el) {
    return (map[ind1][ind2].a, map[ind1][ind2].b, map[ind1][ind2].arr[ind3]);
  }

  function SetMappingLength (uint ind1, uint length) ownerOnly() public {
    map[ind1].length = length;
  }

  function SetMappingElLength (uint ind1, uint ind2, uint length) ownerOnly() public {
    map[ind1][ind2].arr.length = length;
  }

  function SetMapping (uint ind1, uint ind2, uint a, uint b, uint ind3, uint val3) ownerOnly() public {
    data storage dloc = map[ind1][ind2];
    dloc.a = a;
    dloc.b = b;
    dloc.arr[ind3] = val3;
  }
}

