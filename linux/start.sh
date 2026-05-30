#!/usr/bin/env bash
# ============================================================
#  tw-pearl-miner (Linux) — edit WALLET below, then run:
#     chmod +x start.sh && ./start.sh [worker-name]
#  Keep this script next to pearl-gpu-miner + the two .so files.
#  Pool is built in (pearl.tw-pool.com:50001).
# ============================================================

# ---- your settings ----
WALLET="YOUR_PRL_WALLET_ADDRESS"
WORKER="${1:-$(hostname -s)}"
# Uncomment for a plaintext pool (no TLS):
# export POOL_TLS=0
# -----------------------

cd "$(dirname "$0")"
export LD_LIBRARY_PATH="$(pwd):${LD_LIBRARY_PATH:-}"

if [ "$WALLET" = "YOUR_PRL_WALLET_ADDRESS" ] || [ -z "$WALLET" ]; then
  echo "Edit start.sh and set WALLET to your prl1... payout address."
  exit 1
fi

echo "Starting tw-pearl-miner  (worker: $WORKER)"
exec ./pearl-gpu-miner --wallet "$WALLET" --worker "$WORKER"
