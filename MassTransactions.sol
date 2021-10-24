pragma ton-solidity >= 0.47.0;
pragma AbiHeader expire;

/*
This contract for mass transaction generation in TON Blockchain
Usage: 
1. Deploy this contract. Add a lot of funds to this contract.
2. Call function start
*/
contract MassTransactions {    

    uint counter = 0;
    address static m_parent;
    bool deployed = false;
    
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
        uint128 value = address(this).balance - 4e8;
      	return  new MassTransactions{		
			code: tvm.code(),			
			value: value,						
			varInit: {	
                m_parent: address(this)							
			}
		}(); 
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
