#!/usr/bin/env bash

set -o errexit

tondev se reset
tondev network default se
rm -fr *.abi.json *.tvc

# Deploy Pong Contract
tondev sol compile Pong.sol
tondev contract deploy Pong --value 1000000000
pongAddress=$(tondev contract info Pong | grep Address | cut -d':' -f3 | cut -d' ' -f1)
echo "$pongAddress"

# Deploy Ping Contract
tondev sol compile Ping.sol
tondev contract deploy Ping --value 1000000000
pingAddress=$(tondev contract info Ping | grep Address | cut -d':' -f3 | cut -d' ' -f1)
echo "$pingAddress"

# Run
tondev contract run Ping run --input "pong:$pongAddress,a:1" &> /dev/null
tondev contract run-local Ping tmp | grep tmp
# tmp:0x0000000000000000000000000000000000000000000000000000000000000003

tondev contract run Ping run --input "pong:$pongAddress,a:1" &> /dev/null
tondev contract run-local Ping tmp | grep tmp
# tmp:0x0000000000000000000000000000000000000000000000000000000000000006