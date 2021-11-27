tondev network default se
tondev se reset

#deploy
tondev sol compile Emit.sol
tonos-cli genaddr --genkey ./Emit.keys.json ./Emit.tvc ./Emit.abi.json
tondev signer add emit ./Emit.keys.json
tondev contract deploy Emit.abi.json --signer emit --value 1000000000

#test
tondev contract run Emit.abi.json send --signer emit 

tondev signer delete emit