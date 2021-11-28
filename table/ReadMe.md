With tonos-cli u can easily send complicated structures to contract.

Store it in args.json file before.

And pass it like this

```
tonos-cli deploy --abi Table.abi.json --sign Table.keys.json Table.tvc "$(cat args.json)"
```
