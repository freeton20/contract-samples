pragma ton-solidity >= 0.47.0;
pragma AbiHeader expire;

/*
This contract for mass transaction generation in TON Blockchain
Usage: 
1. Deploy this contract. Add a lot of funds to this contract.
For example, you can get in fld network 100_000 tokens. 
2. Call function start
*/
contract MassTransactions {    

    uint counter = 0;
    bool deployed = false;  
    address static m_parent; 
    
    function send(address dest, uint128 value) public{              
            dest.transfer(value, false, 1);        
            tvm.accept();   
            counter++;        
    }

    function count() public returns(uint){
        tvm.accept();
        return counter;
    }

    function deployer()
		public		
		returns (address)
	{
        tvm.accept();
        (uint128 remainingBalance,) = calculateRemainingBalance();
        uint128 value = address(this).balance - remainingBalance;       
      	return  new MassTransactions{		
			code: tvm.code(),			
			value: value,						
			varInit: {
                m_parent: address(this)	            						
			}
		}(); 
	}

    function calculateRemainingBalance() public returns(uint128 remainingBalance, uint totalContracts){
        tvm.accept();
        remainingBalance = 0;
        totalContracts = 0;
        int totalAmount = address(this).balance;
        uint128 diff = 11e6;
        while(totalAmount > 0) {
            remainingBalance += diff;
            totalAmount -= remainingBalance;  
            totalContracts++;
        }               
    }  

    function start() public{
        tvm.accept();
        deployed = true;
        address child = deployer();
        send(child, 1e7);
    }

    function isDeployed() public returns(bool){
        tvm.accept();
        return deployed;
    }

    receive () external {                      
        if(isDeployed() == false){                   
            start();           
        }
        send(msg.sender, msg.value);          
    }     
}
