# Mainnet

This repository is used to provide resources for archway mainnet launch.

## Process

1. Validators create a PR to this repository. That PR must include:
   1. `gentx` json file with the default generated filename put inside the `archway-1/gentx` folder (Validator must not modify the name of the generated gentx file).
1. When all Gentx files have been collected, Coordinator creates the final `genesis` file
1. Coordinator uploads the final genesis file to this repository under the `archway-1/genesis` folder
1. Coordinator starts their nodes and provides a list of `seed` & `persistent peers` that Validators will use to configure their servers.
1. Validators can then start their nodes in coordinated fashion after Coordinator gives a go ahead.

## Documentation

More information how to become a validator can be found from Archway's documentation <https://docs.archway.io/validators/becoming-a-validator/overview>

## Configuration

| Name      | Value                                                         | Description                         |
| --------- | ------------------------------------------------------------- | ----------------------------------- |
| ChainID   | archway-1                                                     | Name of the chain that will be used |
| Seed node | 3ba7bf08f00e228026177e9cdc027f6ef6eb2b39@35.232.234.58:26656  | Seed nodes to be configured         |
