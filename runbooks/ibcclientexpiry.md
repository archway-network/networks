# IBC Client Expiry

## Meaning

IBC Client on the channel is close to be expired

## Impact

If IBC client expires a new channel needs to be created for the IBC path,
which can be very inconvenient.

## Diagnosis

Verify when does the client expire and update the clients in the IBC path if necessary.

You can check the expiry with:

```shell
hermes query client status --chain <CHAIN_ID> --client <CLIENT_ID>
```

or

```shell
rly query clients-expiration <path>
```

## Mitigation

The clients need to be updated in the IBC path, this generates new IBC transaction
which updates the client.

```shell
hermes update client [OPTIONS] --host-chain <HOST_CHAIN_ID> --client <CLIENT_ID>
```

or

```shell
rly transact update-clients <path>
```
