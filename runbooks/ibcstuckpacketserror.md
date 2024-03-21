# IBC Stuck Packets Error

## Meaning

Relayer exporter failed to get metrics about stuck packets from the configured RPC endpoint

## Impact

IBC stuck packets monitoring for this particular connection is currently offline

## Diagnosis

Verify that the configured RPCs on the problemetic path are working and are not being rate limited. You can check for errors in the relayer exporter logs

## Mitigation

Replace the faulty RPC endpoint in relayer exporter configs.
