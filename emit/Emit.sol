pragma ton-solidity >= 0.47.0;

contract EmitTest {
    event test(uint i);
    function send() public{
        tvm.accept();
        emit test(1);//gas 0.006626085
        address a = address.makeAddrStd(0, 0xd5f5cfc4b52d2eb1bd9d3a8e51707872c7ce0c174facddd0e06ae5ffd17d2fcd);
        a.transfer(1e7);
        emit test(2);
    }
}