pragma solidity ^0.7.0;

contract DeedMultiPayout {
  address lawyer;
  address payable beneficiary;
  uint earliest;
  uint amount;
  uint constant PAYOUTS = 10;
  uint constant INTERVAL = 5;
  uint public paidPayouts;
  
  constructor(
    address _lawyer,
    address payable _beneficiary,
    uint fromNow)
    payable
      {
        lawyer = _lawyer;
        beneficiary = _beneficiary;
        earliest = block.timestamp + fromNow;
        amount = msg.value / PAYOUTS;
    }
  
  function withdraw() public {
    require(msg.sender == beneficiary, 'beneficiary only');
    require(block.timestamp >= earliest, 'too early');
    require(paidPayouts < PAYOUTS, 'no payout left');
    
    uint elligiblePayouts = (block.timestamp - earliest) / INTERVAL;
    uint duePayouts = elligiblePayouts - paidPayouts;
   // duePayouts = duePayouts + paidPayouts > PAYOUTS ? PAYOUTS - paidPayouts : duePayouts;
   if(duePayouts + paidPayouts > PAYOUTS){
      duePayouts = PAYOUTS - paidPayouts;
   }
    paidPayouts += duePayouts;
    beneficiary.transfer(duePayouts * amount);
  }
}