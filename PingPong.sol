pragma ton-solidity >= 0.47.0;
pragma AbiHeader expire;
/*
    Create and deploy two contracts with such code
    Call one of them with send function
*/
contract PingPong {
    uint counter = 0;
    
    function send(address dest, uint128 value) public{              
            dest.transfer(value, true, 1);        
            tvm.accept();   
            counter++;        
    }

    function count() public returns(uint){
        tvm.accept();
        return counter;
    } 

    receive () external {
        send(msg.sender, msg.value);
    }     
}
