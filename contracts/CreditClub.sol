pragma solidity ^0.5.0;

contract CreditClub {

  mapping(address => bool) public admin;

  struct Credit {
    address payable beneficiary;
    uint amount;
    bool paidOut;
  }
  struct Inflow {
    uint amount;
    uint date;
  }

  Credit[] public creditList;
  Credit[] public outflows;

  uint public payoutIndex;
  uint public totalPayouts;
  uint public total;

  mapping(address => bool) public members;
  mapping(address => Inflow[]) public inflows;
  mapping(address => uint) public totals;

  uint public eligibilityFloor = 300;

  modifier onlyMembers() {
    require(members[msg.sender] == true);
    _;
  }
  modifier onlyAdmin() {
    require(admin[msg.sender] == true);
    _;
  }

  constructor() public {
    members[msg.sender] = true;
    admin[msg.sender] = true;
  }

  function join() public {
    members[msg.sender] = true;
  }

  function makePayment() public onlyMembers payable {
    inflows[msg.sender].push(Inflow(msg.value,now));
    totals[msg.sender] += msg.value;
    total += msg.value;
  }

  function requestCredit(uint _creditRequested) public onlyMembers {
    require(totals[msg.sender] >= eligibilityFloor);
    creditList.push(Credit(msg.sender,_creditRequested,false));
  }

  function payOut() public onlyAdmin {
    address payable beneficiary = creditList[payoutIndex].beneficiary;
    uint amount = creditList[payoutIndex].amount;
    beneficiary.transfer(amount);

    creditList[payoutIndex].paidOut = true;
    totalPayouts += amount;
    payoutIndex += 1;
    outflows.push(Credit(beneficiary,amount,true));
  }

}
