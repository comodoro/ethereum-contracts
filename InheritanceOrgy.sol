import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract owned {
    function owned() { owner = msg.sender; }
    address owner;
}

contract priced {
    
    function priced(uint256 _price) { price = _price; } 
    
    //price of the token in wei
    uint256 public price;

}

contract BuyableToken is priced, StandardToken {
    
    //If Ether is sent to this contract, grab it and increase msg.sender balance
    function () payable {
        balances[msg.sender] += msg.value * price; 
    }
}

contract SellableToken is priced, StandardToken {
    
    //Allow anyone to withdraw at the current price
    function withdraw(uint256 _value) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            msg.sender.send(_value / price);
        }
    }
}

contract VariablePriceToken is BuyableToken, SellableToken {
    
    uint32 public startTime;
    //price changes linearly as 1/256 * (time - startTime) * this value
    uint16 public steepness;
    
    function RisingPriceToken(uint32 _startTime, uint16 _steepness) {
        startTime = _startTime;
        steepness = _steepness;
    }
    
    function update() {
                price = price / 256 * steepness * (block.timestamp - startTime);
    }

    function () payable {
        update();
        balances[msg.sender] += msg.value * price; 
    }
 
    function withdraw(uint256 _value) {
        update();
        super.withdraw(_value);
    }
  
}