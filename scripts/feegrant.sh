#!/usr/bin/env bash

set -eu

# Static variables
DATE=$(date -d@"$((`date +%s`+2592000))" +"%Y-%m-%dT08:10:00Z")
CHAIN_ID="archway-1"
NODE_URL="https://rpc.mainnet.archway.io:443"
ALLOWED_MESSAGES="/ibc.core.channel.v1.MsgTimeout,/ibc.core.client.v1.MsgUpdateClient,/ibc.core.channel.v1.MsgAcknowledgement,/ibc.core.channel.v1.MsgRecvPacket,/ibc.applications.transfer.v1.MsgTransfer"
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
echo "$MNEMONIC" | archwayd keys add mainnet-relayer-archway --keyring-backend test --recover

# Start the check
# Get all operators and if it's null exit with error
OPERATORS=$(get_operators)
if [[ "$OPERATORS" == "null" ]]; then
  echo "Error: Could not find any operators" >&2
  exit 1
fi

# Checks every operator address if it can find active feegrant
# if $GRANT length less or equal to 0, create the fee grant
for operator in $OPERATORS; do
  echo "Checking operator ${operator}" >&2
  GRANT=$(archwayd q feegrant grants-by-grantee "$operator" --node https://rpc.mainnet.archway.io:443 -o json |jq '.allowances | length' )
  if [[ -z "$GRANT" ]]; then
    exit 1
  fi
  if [[ "$GRANT" -le 0 ]]; then
    echo "Did not find fee grant for ${operator}" >&2
    create_grant
  fi
done

echo "Done" >&2
exit 0
