#!/usr/bin/env bash

set -eu

# Static variables
DATE=$(date -d@"$((`date +%s`+2592000))" +"%Y-%m-%dT08:10:00Z")
CHAIN_ID="archway-1"
NODE_URL="https://rpc.mainnet.archway.io:443"
ALLOWED_MESSAGES="/ibc.core.client.v1.MsgCreateClient,/ibc.core.client.v1.MsgUpdateClient,/ibc.core.client.v1.MsgUpgradeClient,/ibc.core.client.v1.MsgSubmitMisbehaviour,/ibc.core.client.v1.MsgRecoverClient,/ibc.core.client.v1.MsgIBCSoftwareUpgrade,/ibc.core.client.v1.MsgUpdateClientParams,/ibc.core.connection.v1.MsgConnectionOpenInit,/ibc.core.connection.v1.MsgConnectionOpenTry,/ibc.core.connection.v1.MsgConnectionOpenAck,/ibc.core.connection.v1.MsgConnectionOpenConfirm,/ibc.core.connection.v1.MsgUpdateConnectionParams,/ibc.core.channel.v1.MsgChannelOpenInit,/ibc.core.channel.v1.MsgChannelOpenTry,/ibc.core.channel.v1.MsgChannelOpenAck,/ibc.core.channel.v1.MsgChannelOpenConfirm,/ibc.core.channel.v1.MsgChannelCloseInit,/ibc.core.channel.v1.MsgChannelCloseConfirm,/ibc.core.channel.v1.MsgRecvPacket,/ibc.core.channel.v1.MsgTimeout,/ibc.core.channel.v1.MsgTimeoutOnClose,/ibc.core.channel.v1.MsgAcknowledgement,/ibc.applications.transfer.v1.MsgTransfer,/ibc.applications.transfer.v1.MsgUpdateParams"
GRANT_AMOUNT="1000"

DATA=$(cat "$1")

# Gets all operator addresses
function get_operators() {
  echo "Getting operators" >&2
  echo "$DATA" |jq -r '.operators | .[].chain_1.address'
}

# Creates the fee grant with predetermined settings
function create_grant() {
  echo "Creating grant for $operator" >&2
  archwayd tx feegrant grant mainnet-relayer-archway "$operator" \
           --allowed-messages "$ALLOWED_MESSAGES" \
           --spend-limit "$GRANT_AMOUNT"000000000000000000aarch --expiration "$DATE" --chain-id "$CHAIN_ID" --node "$NODE_URL" \
           --gas-prices $(archwayd q rewards estimate-fees 1 --node "$NODE_URL" --output json | jq -r '.gas_unit_price | (.amount + .denom)') \
           --from mainnet-relayer-archway --keyring-backend test -y >&2
}

# Authenticate
KEY=$(archwayd keys list --output json --keyring-backend test |jq -r '.[] | select(.name=="mainnet-relayer-archway")' )
if [[ -z "$KEY" ]]; then
  echo "Could not find mainnet-relayer-archway key, adding it" >&2
  echo "$MNEMONIC" | archwayd keys add mainnet-relayer-archway --keyring-backend test --recover
fi

# Start the check
# Get all operators and if it's null exit with error
OPERATORS=$(get_operators)
if [[ "$OPERATORS" == "null" ]]; then
  echo "Could not find any operators" >&2
  exit 0
fi

# Checks every operator address if it can find active feegrant
# if $GRANT length less or equal to 0, create the fee grant
for operator in $OPERATORS; do
  echo "Checking operator ${operator}" >&2
  GRANT=$(archwayd q feegrant grants-by-grantee "$operator" --node "$NODE_URL" -o json |jq '.allowances | length' )
  if [[ -z "$GRANT" ]]; then
    exit 1
  fi
  if [[ "$GRANT" -eq 0 ]]; then
    echo "Did not find fee grant for ${operator}" >&2
    create_grant
  fi
done
