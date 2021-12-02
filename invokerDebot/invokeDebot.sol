pragma ton-solidity >=0.46.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
import "https://raw.githubusercontent.com/tonlabs/debots/main/Debot.sol";
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Terminal/Terminal.sol";

interface IWallet {
    function sendTransaction(
        address  dest,
        uint128 value,
        bool bounce,
        uint8 flags,
        TvmCell payload)
    external;
}

contract InvokeDebot is Debot{

    function start() public override {       
    }   
    
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Test DeBot";
        version = "0.0.1";
        publisher = "publisher name";
        key = "How to use";
        author = "Author name";
        support = address.makeAddrStd(0, 0x000000000000000000000000000000000000000000000000000000000000);
        hello = "Hello, i am an test DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = '';
    }
    
    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }   

    function sendTransaction(address sender, address receiver, uint128 amount, bool bounce, uint8 flags) public {         
        optional(uint256) pubkey = 0;     
        //deposit                        
        TvmCell payload;             
        IWallet(sender).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)      
        }(receiver, amount, bounce, flags, payload);        
    }  

     function onSuccess() public{                                        
        Terminal.print(0, format("Success!"));  
        start();       
    } 
    
    function onError() public{        
        Terminal.print(0, format("Error"));        
    }

    function getInvokeMessage(address sender, address receiver, uint128 amount, bool bounce, uint8 flags) public pure
        returns(TvmCell message) {
        TvmCell body = tvm.encodeBody(InvokeDebot.sendTransaction, sender, receiver, amount, bounce, flags);
        TvmBuilder message_;
        message_.store(false, true, true, false, address(0), address(this));
        message_.storeTons(0);
        message_.storeUnsigned(0, 1);
        message_.storeTons(0);
        message_.storeTons(0);
        message_.store(uint64(0));
        message_.store(uint32(0));
        message_.storeUnsigned(0, 1); //init: nothing$0
        message_.storeUnsigned(1, 1); //body: right$1
        message_.store(body);
        message = message_.toCell();
    }
}
