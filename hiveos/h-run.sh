#!/usr/bin/env bash
cd "$(dirname "$0")"
MINER_DIR="$(pwd)"

. h-manifest.conf
[[ -e $CUSTOM_CONFIG_FILENAME ]] && . "$CUSTOM_CONFIG_FILENAME"

# the kernel .so + cudart ship alongside the binary
export LD_LIBRARY_PATH="$MINER_DIR:${LD_LIBRARY_PATH:-}"

# pool override (blank -> built-in pearl.tw-pool.com:50001)
[[ -n $POOL_HOST ]] && export POOL_HOST
[[ -n $POOL_PORT ]] && export POOL_PORT
[[ -n $POOL_TLS  ]] && export POOL_TLS

mkdir -p "$(dirname "$CUSTOM_LOG_BASENAME")"

[[ -z $WALLET ]] && { echo "tw-pearl-miner: no wallet set (flight sheet 'Wallet and worker template')"; sleep 10; exit 1; }

# Run; tee to the log file h-stats.sh parses (HiveOS also captures stdout via screen).
./pearl-gpu-miner --wallet "$WALLET" --worker "${WORKER:-$(hostname -s)}" 2>&1 | tee "${CUSTOM_LOG_BASENAME}.log"
