pragma ton-solidity >= 0.47.0;

contract EmitTest {
    event test(uint i);
    function send() public{
        tvm.accept();
        emit test(256);
    }
}