# Archway Netowrks

This repo contains a chain.json and assetlist.json for Archway Protocol based networks. A chain.json contains data that makes it easy to start running or interacting with a node.

Schema files containing the recommended metadata structure can be found in the *.schema.json files located in the root directory. Schemas are still undergoing revision as user needs are surfaced. Optional fields may be added beyond what is contained in the schema files.

# Adding new IBC paths

If you are a relayer operator and wish to add a new IBC path connecting to Archway Networks, please follow the below mentioned criteria and create a PR after creating the path.
## Requirements for the IBC channel:
- Archway client's trusting period should be set to 2/3 of unbonding period e.g. for archway-1 (mainnet) the clients trusting period must be 1209600s
- IBC client for your chain should also have trusting period set to exactly 2/3 of your unbonding period

## Steps to create new IBC paths

We recommend using hermes relayer implementation and use this [tutorial](https://hermes.informal.systems/tutorials/local-chains/add-a-new-relay-path.html) to create new paths.

# Requesting a new IBC path

If you are builder on Archway protocol and/or looking to connect Archway Networks to another chain through IBC, but do have the expertise or the capacity to operate relayers, you can still create an issue with a proposal in this repo requesting a new path and we would try our best to get that public infrastructure setup.

# Feegrants Program

Relayers operating IBC paths connecting to archway-1 (mainnet) may apply for a feegrant to pay for IBC transfer fees.

To apply for a feegrant fill out the following form: https://forms.gle/AfUbwRpHU5XGBquM6
