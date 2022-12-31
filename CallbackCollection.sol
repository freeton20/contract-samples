pragma ever-solidity >=0.60.0;

contract CallbackCollection {
	struct CallbackFunctions {
		function(uint256, uint256) returns (uint256) func;
	}

	mapping(string => CallbackFunctions[]) functionSet;

	function createCalculator() public {
		tvm.accept();
		functionSet["calculator"] = [CallbackFunctions(plus)];
	}

	function plus(uint256 a, uint256 b) public pure returns (uint256) {
		return a + b;
	}

	function testCalc() public returns (uint256) {
		return functionSet["calculator"][0].func(1, 2);
	}
}
