#!/usr/bin/env bash

set -uo pipefail
${TRACE:+set -x}

CHAIN_FILE=$1
THRESHOLD=${THRESHOLD:-30}
TIMEOUT=${TIMEOUT:-5}

is_synced() {
    local block_time=$1

    if [[ -z $block_time ]]; then
        echo "Error: Block time for endpoint is empty" >&2
        exit 1
    fi

    if [[ $block_time = "null" ]]; then
        echo "Error: Block time for endpoint is null" >&2
        exit 1
    fi

    diff=$(echo "{\"time\": $block_time}" | jq '(now - (.time | split(".")[0] + "Z" | fromdate)) | trunc')
    if [[ $? -gt 0 ]]; then
        exit 1
    fi

    echo "Latest block is from $diff seconds ago" >&2
    if [[ $diff -gt $THRESHOLD ]]; then
        echo "Error: Endpoint is not synced" >&2
        exit 1
    fi
}

check_rpc() {
    local endpoint=$1
    echo "Checking RPC endpoint $endpoint" >&2
    block_time=$(curl -f -s -S --connect-timeout $TIMEOUT --max-time $TIMEOUT $endpoint/status | jq '.result.sync_info.latest_block_time')
    is_synced "$block_time"
}

check_rest() {
    local endpoint=$1
    echo "Checking REST endpoint $endpoint" >&2
    block_time=$(curl -f -s -S --connect-timeout $TIMEOUT --max-time $TIMEOUT $endpoint/blocks/latest | jq '.block.header.time')
    is_synced "$block_time"
}

check_grpc() {
    local endpoint=$1
    local service="cosmos.base.tendermint.v1beta1.Service/GetLatestBlock"
    local cmd="grpcurl --connect-timeout $TIMEOUT --max-time $TIMEOUT $endpoint $service"
    local cmd_plain="grpcurl --plaintext --connect-timeout $TIMEOUT --max-time $TIMEOUT $endpoint $service"
    echo "Checking gRPC endpoint $1" >&2
    block_time=$($cmd | jq '.block.header.time' || $cmd_plain | jq '.block.header.time')
    is_synced "$block_time"
}

check_endpoint() {
    local endpoint=$1
    local type=$2

    case $type in
        rpc)
            check_rpc $endpoint
            ;;
        rest)
            check_rest $endpoint
            ;;
        grpc)
            check_grpc $endpoint
            ;;
        *)
            echo "Warning: Unknown type '$type', supported types: rpc|rest|grpc" >&2
            ;;
    esac
}

changed_endpoints=($(git diff origin/main $CHAIN_FILE | grep '^\+\s*"address"' | sed -n 's/^.*"\(.*\)".*$/\1/p'))

declare -i result=0
for endpoint in "${changed_endpoints[@]}"; do
    type=$(cat $CHAIN_FILE | jq -r "first(path(recurse | select(.==\"$endpoint\"))) | .[1]")

    case $type in
        rpc | rest | grpc)
            $(check_endpoint $endpoint $type)
            ;;
        *)
            echo "Ignoring type $type for endpoint $endpoint" >&2
            ;;
    esac

    result=$(($result+$?))
done

if [[ "$result" -gt 0 ]]; then
    echo "Error: Some changed endpoints are not working properly" >&2
    exit 1
fi
