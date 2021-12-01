tondev se reset &> /dev/null
tondev network default se
echo 'reset'
echo '-------------deploy surf account-----------'
tondev contract deploy multisig.abi.json --signer multisig --value 1000000000000 --input "owners:[0xf79c10f99a2748edc9dff1ff6b95c74764aa0d2f271c7911b9104aaee0daa45f],reqConfirms:1"
echo '-------------deploy debot-------------------'
debotName=SenderDebot
tondev sol compile $debotName.sol
tondev contract deploy $debotName --value 100000000  &> /dev/null
debotAddress=$(tondev contract info $debotName | grep Address | cut -d':' -f3 | cut -d' ' -f1)

debotAbi=$(cat $debotName.abi.json | xxd -ps -c 20000)
tondev contract run $debotName setABI --input "dabi:'$debotAbi'"
echo "$debotAddress"
tonos-cli --url http://net.ton.dev debot --debug fetch 0:$debotAddress