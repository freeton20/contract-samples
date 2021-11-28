pragma ton-solidity >= 0.52.0;

contract Table {
    struct row{
        int i;
        string s;
    }
    constructor(row r) public {
        tvm.accept();
    }
}