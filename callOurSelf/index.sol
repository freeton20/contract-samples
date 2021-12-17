pragma ton-solidity >= 0.53.0;
pragma AbiHeader expire;

contract Index {  
    uint public counter = 0;
    function test() public{
        tvm.accept();
        counter++;
        this.test();
    }
}