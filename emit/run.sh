
#!/usr/bin/env bash
tondev se reset
tondev sol compile Emit.sol

tondev contract deploy Emit --value 1000000000 

tondev contract run Emit send

