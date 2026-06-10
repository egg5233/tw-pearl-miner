#!/usr/bin/env bash
# ============================================================
#  tw-pearl-miner (Linux) — edit WALLET and POOL below, then run:
#     chmod +x start.sh && ./start.sh [worker-name]
#  Keep this script next to pearl-gpu-miner + the two .so files.
#
#  POOL is REQUIRED — this miner has no built-in pool. Set it to
#  your mining pool's host:port. For a pool that needs an explicit
#  transport, prefix the scheme, e.g.:
#      POOL="stratum+ssl://your.pool.host:port"
#      POOL="stratum+tcp://your.pool.host:port"
# ============================================================

# ---- your settings ----
WALLET="YOUR_PRL_WALLET_ADDRESS"
POOL="YOUR_POOL_HOST:PORT"
WORKER="${1:-$(hostname -s)}"
# -----------------------

cd "$(dirname "$0")"
chmod +x ./pearl-gpu-miner 2>/dev/null || true   # unzip drops the +x bit; restore it
export LD_LIBRARY_PATH="$(pwd):${LD_LIBRARY_PATH:-}"

if [ "$WALLET" = "YOUR_PRL_WALLET_ADDRESS" ] || [ -z "$WALLET" ]; then
  echo "Edit start.sh and set WALLET to your prl1... payout address."
  exit 1
fi
if [ "$POOL" = "YOUR_POOL_HOST:PORT" ] || [ -z "$POOL" ]; then
  echo "Edit start.sh and set POOL to your mining pool (host:port, or stratum+ssl://host:port)."
  exit 1
fi

echo "Starting tw-pearl-miner  (pool: $POOL, worker: $WORKER)"
exec ./pearl-gpu-miner --pool "$POOL" --wallet "$WALLET" --worker "$WORKER"
