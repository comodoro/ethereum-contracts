pragma solidity ^0.4.12;

contract lockable {

    uint32 locked;
    
    function lock(uint32 blocks) {
        locked += blocks;
    }
    
    function withdraw(uint _amount) {
        if (_amount <= 0)  or (_amount > this.balance) or (locked >= block.number) throw;
        msg.sender.send(_amount)
    }
    
}