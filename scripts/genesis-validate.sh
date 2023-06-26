#!/bin/bash
set -eu

# Archway default test configuration
# Command
ARCHD="./archwayd"
# Operating Directory
ARCHDIR=".archway"
GENTX_FILE=$1

# Network
NETWORK="archway-1"

# Timeout
TIMEOUT="60"

# Required fee
REQ_FEE="180000000000000000"

LOGS_FILE="logs.txt"

# copy initial genesis
mkdir -p $ARCHDIR/config/gentx
#gunzip $NETWORK/init_genesis.json.gz
cp $NETWORK/init_genesis.json $ARCHDIR/config/genesis.json

# check that GENTX_FILE is not empty
if [ -z "$GENTX_FILE" ]; then
    echo "GENTX_FILE is empty"
    exit 1
fi

# check that gentx is valid
cp "$GENTX_FILE" $ARCHDIR/config/gentx/

# check that gentx fee value is equal to required fee value
echo "Checking gentx fee"
GENTX_FEE=$(jq -r '.auth_info.fee.amount[0].amount' "$GENTX_FILE")
if [ "$GENTX_FEE" == null ]; then
    echo "Gentx fee is empty"
    exit 1
fi
if [ "$GENTX_FEE" -lt "$REQ_FEE" ]; then
    echo "Gentx fee is less than minimum required fee: $GENTX_FEE / $REQ_FEE"
    exit 1
fi


# collect gentx
echo "Collecting gentx"
$ARCHD collect-gentxs --home $ARCHDIR >> $LOGS_FILE 2>&1 || true
if grep failed $LOGS_FILE; then
  tail -n1 $LOGS_FILE
  exit 1
fi

# validate genesis
echo "Validating genesis"
$ARCHD validate-genesis --home $ARCHDIR >> $LOGS_FILE 2>&1 || true
if grep failed $LOGS_FILE; then
  tail -n1 $LOGS_FILE
  exit 1
fi

# start node and shut it down after timeout
echo "Starting node"
$ARCHD start --home $ARCHDIR >> $LOGS_FILE 2>&1 &

COUNT=0
while true; do
  if [ $(($COUNT*5)) -ge $TIMEOUT ]; then
    echo "Timeout reached"
    break
  fi
  # check for panics
  if  grep panic: $LOGS_FILE; then
    tail -n1 $LOGS_FILE
    echo "Panic found in log"
    exit 1
  fi
  sleep 5
  ((COUNT=COUNT+1))
done

# kill archwayd
kill $(pgrep archwayd)

echo "Gentx is valid"
# echo last lines of log
tail -n5 $LOGS_FILE
