# Archway Netowrks

This repo contains a registry of Archway protocol based networks, IBC connections to these networks.

Schema files containing the recommended metadata structure can be found in the *.schema.json files located in the root directory. Schemas are still undergoing revision as user needs are surfaced. Optional fields may be added beyond what is contained in the schema files.

## Adding new IBC paths

If you are a relayer operator and wish to add a new IBC path connecting to Archway Networks, please follow the below mentioned criteria and create a PR after creating the path.

### Requirements for the IBC channel

- Archway client's trusting period should be set to 2/3 of unbonding period e.g. for archway-1 (mainnet) the clients trusting period must be 1209600s
- IBC client for the counterparty chain should also have a trusting period set to exactly 2/3 of the chains unbonding period

### Steps to create new IBC paths

We recommend using hermes relayer implementation and use this [tutorial](https://hermes.informal.systems/tutorials/local-chains/add-a-new-relay-path.html) to create new paths.

## Requesting a new IBC path

If you are a builder on the Archway protocol and/or looking to connect Archway Networks to another chain through IBC, but do not have the expertise or the capacity to operate relayers, you can request the desired IBC relayer from archway community:

- Join [Arcway Discord](https://discord.gg/5FVvx3WGfa)
- Use "@Mainnet Validator" or "@Relayer" tag on discord to request a new relay path from within Archway Network operators and partners
  - Suitable channel for such requests: "build-together"
  - You may use the "@Community Mods" discord tag for Archway community moderators and/or the "@DevRel" discord tag for Philabs developer relations team, to ask for help in your search of finding a new relayer partner
- Each relayer connecting the cosmos to Archway networks is eligible for a feegrant to pay for IBC transfer on Archway mainnet. Please check [feegrants program](#feegrants-program) below for more details

## Monitoring IBC paths

Philabs (on behalf of Archway foundation) is building monitoring tools e.g. [relayer_exporter](https://github.com/archway-network/relayer_exporter) and also leveraging existing tools like [chainpulse](https://github.com/informalsystems/chainpulse). These monitoring tools will be used to monitor relayers and IBC paths published on this repo for the following metrics

- [x] Client Expiry
- [x] Total IBC packets transmitted
- [ ] Fee paid per packet transmitted
- [ ] Redundant packets transmitted
- [ ] Stuck packets
- [ ] Account balances
  - [x] Philabs operated relayers
  - [x] Foundation feegranter account balance (this account is used to provide feegrants for relayers)
  - [ ] External relayers account balances

## Feegrants Program

All relayers operating IBC paths connecting to Archway mainnet are eligible for a feegrant to pay for IBC transaction fees on Archway network.

### Feegrant selection criteria:

- Feegrants programs aims to have availablity of maximum 2 to 3 relayers on each published path
- Feegrants will be reviewed based relayer performance
- Relayer must have local full nodes available for both connecting chains
- Relayer must publish its metadata and signer addresses for both connecting chains. Please use [ibc_data_schema.json](../ibc_data.schema.json) for schema reference.
- Relayer must update the [Active Feegrants](#active-feegrants) below.


### Active Feegrants

|                                            | Osmosis | Cosmoshub | Axelar | Umee | Jackal | Kujira | Juno | Agoric | Ojo | Noble | Nois |
| ------------------------------------------ | ------- | --------- | ------ | ---- | ------ | ------ | ---- | ------ | --- | ----- | ---- |
| Phi Labs                                   | ✓       | ✓         | ✓      |      |        |        |      |        |     |       |      |
| MZONDER                                    | ✓       | ✓         | ✓      | ✓    |        |        |      |        |     |       |      |
| Crosnest                                   | ✓       | ✓         | ✓      |      |        |        |      |        |     |       |      |
| Nodes.Guru                                 | ✓       |           | ✓      |      |        |        |      |        |     |       |      |
| AM Solutions                               |         |           |        | ✓    | ✓      | ✓      |      |        |     |       |      |
| NodeStake                                  |         |           |        |      | ✓      |        |      |        |     |       |      |
| Gelotto                                    |         |           |        |      |        |        | ✓    |        |     |       | ✓    |
| Lavender.Five Nodes                        |         |           |        |      |        |        |      | ✓      |     |       |      |
| kjnodes                                    |         |           |        | ✓    |        | ✓      |      | ✓      |     |       |      |
| DSRV                                       |         |           |        | ✓    |        |        |      |        |     |       |      |
| B-Harvest                                  |         |           |        |      |        |        |      |        |     | ✓     |      |
| Validatrium                                |         |           |        |      |        |        | ✓    |        |     |       |      |
| Architect Nodes                            |         |           |        |      |        |        |      |        |     |       | ✓    |
| DSRV                                       |         |           |        |      |        |        |      |        |     | ✓     |      |
| Ojo                                        |         |           |        |      |        |        |      |        | ✓   |       |      |
| \# of Relayers                             | 4       | 3         | 4      | 4    | 2      | 2      | 2    | 2      | 1   | 2     | 2    |
