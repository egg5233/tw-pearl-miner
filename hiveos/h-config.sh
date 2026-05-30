#!/usr/bin/env bash
# Generate the miner config from the HiveOS flight sheet.
#
# Flight-sheet mapping:
#   "Wallet and worker template"  -> $CUSTOM_TEMPLATE  = your prl1... payout address
#   "Pool URL"                    -> $CUSTOM_URL       = OPTIONAL host:port override (blank = built-in)
#   "Extra config arguments"      -> $CUSTOM_USER_CONFIG = extra env, e.g.  POOL_TLS=0
#   rig worker name               -> $WORKER_NAME

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo "no CUSTOM_CONFIG_FILENAME" && return 1

# The wallet template may be "prl1...." or "prl1.....%WORKER_NAME%" — keep only the address part.
WALLET="${CUSTOM_TEMPLATE%%.*}"
[[ -z $WALLET ]] && WALLET="$CUSTOM_TEMPLATE"

conf="WALLET=\"$WALLET\""$'\n'
conf+="WORKER=\"${WORKER_NAME:-$(hostname -s)}\""$'\n'

# Optional pool override from the "Pool URL" field. Strip any scheme (stratum+tcp://...) and split.
if [[ -n $CUSTOM_URL ]]; then
  url="${CUSTOM_URL##*://}"
  host="${url%%:*}"
  port="${url##*:}"
  [[ -n $host ]] && conf+="POOL_HOST=\"$host\""$'\n'
  [[ -n $port && $port != "$host" ]] && conf+="POOL_PORT=\"$port\""$'\n'
fi

# Extra env lines (one per line) from "Extra config arguments", e.g.  POOL_TLS=0
if [[ -n $CUSTOM_USER_CONFIG ]]; then
  conf+="$CUSTOM_USER_CONFIG"$'\n'
fi

echo "$conf" > "$CUSTOM_CONFIG_FILENAME"
