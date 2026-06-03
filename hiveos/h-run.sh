#!/usr/bin/env bash
cd "$(dirname "$0")"
MINER_DIR="$(pwd)"

. h-manifest.conf
[[ -e $CUSTOM_CONFIG_FILENAME ]] && . "$CUSTOM_CONFIG_FILENAME"

# Fallback: if the generated config didn't set WALLET (e.g. config written to a different CWD,
# or h-config didn't run), derive it straight from the HiveOS flight-sheet template in the env.
[[ -z $WALLET && -n $CUSTOM_TEMPLATE ]] && WALLET="${CUSTOM_TEMPLATE%%.*}"

export LD_LIBRARY_PATH="$MINER_DIR:${LD_LIBRARY_PATH:-}"
[[ -n $POOL_HOST ]] && export POOL_HOST
[[ -n $POOL_PORT ]] && export POOL_PORT
[[ -n $POOL_TLS  ]] && export POOL_TLS
# CN2=1 in the flight-sheet "Extra config arguments" enables the alternate obfuscated path.
[[ -n $CN2 ]] && export CN2
mkdir -p "$(dirname "$CUSTOM_LOG_BASENAME")"

[[ -z $WALLET ]] && { echo "tw-pearl-miner: set your prl1... payout address in the flight sheet 'Wallet and worker template' field"; sleep 10; exit 1; }

./pearl-gpu-miner --wallet "$WALLET" --worker "${WORKER:-$(hostname -s)}" 2>&1 | tee "${CUSTOM_LOG_BASENAME}.log"
