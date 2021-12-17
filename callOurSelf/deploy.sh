set -o errexit

tondev se reset
tondev network default se

tondev sol compile index.sol
indexAddr=$(tondev contract info index | grep Address | cut -d':' -f3 | cut -d' ' -f1)
echo $indexAddr
tondev contract deploy index --value 1000000000

tondev contract run index test

#and then
#tondev contract run-local index counter
