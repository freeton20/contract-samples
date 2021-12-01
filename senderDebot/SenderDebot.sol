pragma ton-solidity >=0.46.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
import "https://raw.githubusercontent.com/tonlabs/debots/main/Debot.sol";
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Terminal/Terminal.sol";
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/AddressInput/AddressInput.sol";
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/AmountInput/AmountInput.sol";
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/UserInfo/UserInfo.sol";

interface IWallet {
    function sendTransaction(
        address  dest,
        uint128 value,
        bool bounce,
        uint8 flags,
        TvmCell payload)
    external;
}
contract Name is Debot{

    address wallet;
    address dest;  
    uint128 amount;  

    function start() public override {       
        UserInfo.getAccount(tvm.functionId(setWallet));   
        AddressInput.get(tvm.functionId(getAddr), "Write destination address");
    }         

    function setWallet(address value) public{           
        wallet = value;                                                 
    }

    function getAddr(address value) public{        
        dest = value;
        AmountInput.get(tvm.functionId(setAmount), "Write amount in evers", 9, 0, 1e11);
    }
    function setAmount(uint128 value) public {
        amount = value;        
        send();
    }
    function send() public {         
        optional(uint256) pubkey = 0;     
        //deposit                    
        TvmCell payload;            
        IWallet(wallet).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)      
        }(dest, amount, true, 3, payload);        
    }

    function onSuccess() public{                                        
        Terminal.print(0, format("Success!"));  
        start();       
    } 
    
    function onError() public{        
        Terminal.print(0, format("Something went wrong. Please try again."));        
    }
    
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Sender debot";
        version = "0.0.1";
        publisher = "everton";
        key = "send tons to surf or safemultisig";
        author = "freeton20";
        support = address.makeAddrStd(0, 0x000000000000000000000000000000000000000000000000000000000000);
        hello = "Hello, i am sender debot. I can send evers to surf or safemultisig wallet";
        language = "en";
        dabi = m_debotAbi.get();
        icon = '';
    }
    
    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }     
}
