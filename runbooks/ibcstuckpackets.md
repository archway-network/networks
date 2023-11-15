# IBC Stuck Packets

## Meaning

There is pending/stuck IBC transfers on the channel

## Impact

IBC transactions are not going through

## Diagnosis

Verify why IBC relayer is not relaying the packets by checking errors from logs.

This can be from numerous reasons like:

- relayer out of funds
- relayer is down

Stuck packets can be found with:

```shell
hermes query packet pending --chain <CHAIN_ID> --port <PORT_ID> --channel <CHANNEL_ID>
```

or

```shell
rly query unrelayed-packets path src_channel_id
```

## Mitigation

There is no one solution to mitigate the issue but you can try clearing stuck packets:

```shell
hermes clear packets [OPTIONS] --chain <CHAIN_ID> --port <PORT_ID> --channel <CHANNEL_ID>
```
