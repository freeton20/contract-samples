tondev network default se
tonos-cli config --url http://localhost &> /dev/null
tondev se reset &> /dev/null

#deploy
tondev sol compile Table.sol
tonos-cli genaddr --genkey ./Table.keys.json ./Table.tvc ./Table.abi.json
tondev signer add table ./Table.keys.json
tondev contract topup Table.abi.json --value 1000000000 --signer table
tonos-cli deploy --abi Table.abi.json --sign Table.keys.json Table.tvc "$(cat args.json)"



tondev signer delete table