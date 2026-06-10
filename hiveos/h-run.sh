#!/usr/bin/env bash
# tw-pearl-miner 2.0.0 — HiveOS launcher.
#
# Reads the argv assembled by h-config.sh (one argument per line) with `mapfile` and execs the miner
# with that exact array. It does NOT source the conf and does NOT export any user-provided env vars:
# in 2.0.0 the only Extra-config form is `--` CLI flags, and the deleted env knobs (CN2, POOL_TLS,
# POOL_PROXY, NO_CPU, POOL_HOST/PORT) are gone. The miner has no built-in pool, so --pool is required.
cd "$(dirname "$0")"
MINER_DIR="$(pwd)"

. h-manifest.conf

mkdir -p "$(dirname "$CUSTOM_LOG_BASENAME")"
LOG="${CUSTOM_LOG_BASENAME}.log"

# Pre-flight failures print to the miner log (HiveOS surfaces it), then pause so the message is visible
# before the agent restarts us. PEARL_HIVE_FAIL_SLEEP overrides the pause (validation harness sets 0).
fail() { echo "tw-pearl-miner: $1" | tee -a "$LOG"; sleep "${PEARL_HIVE_FAIL_SLEEP:-10}"; exit 1; }

[[ -e $CUSTOM_CONFIG_FILENAME ]] || fail "config not generated — re-apply the flight sheet (h-config.sh did not run)."

# Read the assembled argv (one element per line). mapfile, NOT source: conf content is never executed.
mapfile -t MINER_ARGS < "$CUSTOM_CONFIG_FILENAME"

# Legacy NAME=value env token in Extra config (h-config wrote a sentinel) -> clear migration error.
if [[ ${MINER_ARGS[0]} == "__PEARL_LEGACY_ENV__" ]]; then
  fail "Extra config now takes ONLY '--' CLI flags, not env vars. Found a legacy '${MINER_ARGS[*]:1}' token. \
Remove env-style lines (CN2=, POOL_TLS=, POOL_HOST=, NO_CPU= ...) — set the pool in the 'Pool URL' field \
and pass flags like '--gpus 0,1' in Extra config. See hiveos/README.md."
fi

# Pre-flight: --pool and --wallet must be present and not the README placeholders. HiveOS users see
# this in the miner log (the tee target below).
has_flag() { local f="$1"; local a; for a in "${MINER_ARGS[@]}"; do [[ $a == "$f" ]] && return 0; done; return 1; }
flag_val() { local f="$1"; local i; for ((i=0;i<${#MINER_ARGS[@]};i++)); do [[ ${MINER_ARGS[i]} == "$f" ]] && { echo "${MINER_ARGS[i+1]}"; return; }; done; }

has_flag "--pool" || fail "set the Pool URL in the flight sheet, e.g. stratum+ssl://hk.pearl.herominers.com:1200 (2.0.0 has no default pool)."
POOL_VAL="$(flag_val --pool)"
[[ -z $POOL_VAL || $POOL_VAL == "your.pool.host:port" ]] && fail "set the Pool URL in the flight sheet, e.g. stratum+ssl://hk.pearl.herominers.com:1200 (2.0.0 has no default pool)."

has_flag "--wallet" || fail "set your prl1... payout address in the flight sheet 'Wallet and worker template' field."
WALLET_VAL="$(flag_val --wallet)"
[[ -z $WALLET_VAL || $WALLET_VAL == "prl1youraddresshere" ]] && fail "set your prl1... payout address in the flight sheet 'Wallet and worker template' field."

export LD_LIBRARY_PATH="$MINER_DIR:${LD_LIBRARY_PATH:-}"

# stdbuf keeps the hashrate/status lines flowing to the log so h-stats.sh can parse them live; the TUI
# auto-disables because stderr is a pipe (tee), not a terminal — the [status-json]/h-stats contract is
# unchanged from 1.9.x.
exec ./pearl-gpu-miner "${MINER_ARGS[@]}" 2>&1 | tee "$LOG"
