tondev se reset &> /dev/null
tondev network default dev
echo 'reset'
#set custom data
sender=082b695feab5b15a9f4bcb9f007789ffa1ea5d8e588ae1523ff41cad7c430a79
receiver=d5f5cfc4b52d2eb1bd9d3a8e51707872c7ce0c174facddd0e06ae5ffd17d2fcd
amount=100000000

echo '-------------deploy debot-------------------'
debotName=invokeDebot
tondev sol compile $debotName.sol
tondev contract deploy $debotName --value 100000000  &> /dev/null
debotAddress=$(tondev contract info $debotName | grep Address | cut -d':' -f3 | cut -d' ' -f1)

debotAbi=$(cat $debotName.abi.json | xxd -ps -c 20000)
tondev contract run $debotName setABI --input "dabi:'$debotAbi'" &> /dev/null
echo "Debot address: $debotAddress"

message=$(tonos-cli -u http://net.ton.dev run 0:$debotAddress getInvokeMessage "{\"sender\":\"0:$sender\",\"receiver\":\"0:$receiver\",\"amount\":$amount,\"bounce\":true,\"flags\":3}"  --abi $debotName.abi.json \
 | grep message | cut -d '"' -f 4 | tr '/+' '_-' | tr -d '=')
echo "Message: $message" 

echo "Deep link: https://uri.ton.surf/debot?address=0:$debotAddress&message=$message&net=devnet&restart=true"