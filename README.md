# Archway Netowrks

This repo contains a chain.json and assetlist.json for Archway Protocol based networks. A chain.json contains data that makes it easy to start running or interacting with a node.

Schema files containing the recommended metadata structure can be found in the *.schema.json files located in the root directory. Schemas are still undergoing revision as user needs are surfaced. Optional fields may be added beyond what is contained in the schema files.

# Adding new IBC paths

## Requirements for the IBC channel:
- Archway client's trusting period should be set to 2/3 of unbonding period e.g. for archway-1 (mainnet) the clients trusting period must be 1209600s
- IBC client for your chain should also have trusting period set to exactly 2/3 of your unbonding period

## Steps to create new IBC paths

We recommend using hermes relayer implementation and use this [tutorial](https://hermes.informal.systems/tutorials/local-chains/add-a-new-relay-path.html) to create new paths.

# Feegrants Program

Relayers operating IBC paths connecting to archway-1 (mainnet) may apply for a feegrant to pay for IBC transfer fees.

To apply for a feegrant fill fill out the following form: https://forms.gle/AfUbwRpHU5XGBquM6
