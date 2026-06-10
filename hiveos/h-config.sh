#!/usr/bin/env bash
# tw-pearl-miner 2.0.0 — HiveOS flight-sheet -> miner argv.
#
# Paradigm (SRBMiner-custom style): the flight sheet describes the command line, and this script
# assembles the EXACT argv the miner will run, one argument per line, into $CUSTOM_CONFIG_FILENAME.
# h-run.sh reads that file with `mapfile` (it does NOT source it) and execs the binary with the array.
# Nothing the user types is ever sourced/exported as a shell env line.
#
# Flight-sheet field mapping (2.0.0 — the miner has NO built-in pool; --pool is REQUIRED):
#   "Pool URL"                   -> $CUSTOM_URL         -> --pool <VERBATIM, scheme preserved>
#   "Wallet and worker template" -> $CUSTOM_TEMPLATE    -> --wallet <addr>  (a ".worker" suffix, if
#                                                          present, becomes the worker)
#   rig worker name              -> $WORKER_NAME        -> --worker <name>  (fallback: hostname -s)
#   "Extra config arguments"     -> $CUSTOM_USER_CONFIG -> RAW CLI flags appended verbatim, e.g.
#                                                          "--gpus 0,1 --no-tui". NO env-var lines.
#
# Transport is the URL SCHEME (the binary decides), so the scheme is passed through untouched:
#   bare host:port               -> a preset pool (herominers / kryptex / luckypool)
#   stratum+ssl://host:port      -> TLS (verify)
#   stratum+tcp://host:port      -> plaintext
#   stratum+ssl-insecure://host:port -> TLS, no cert verify (e.g. a relay / self-signed front)

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo "no CUSTOM_CONFIG_FILENAME" && return 1

# --- wallet + worker from the template ("addr" or "addr.worker") ---
WALLET="${CUSTOM_TEMPLATE%%.*}"
[[ -z $WALLET ]] && WALLET="$CUSTOM_TEMPLATE"
TEMPLATE_WORKER=""
[[ $CUSTOM_TEMPLATE == *.* ]] && TEMPLATE_WORKER="${CUSTOM_TEMPLATE#*.}"
WORKER="${WORKER_NAME:-$TEMPLATE_WORKER}"
[[ -z $WORKER ]] && WORKER="$(hostname -s 2>/dev/null)"
[[ -z $WORKER ]] && WORKER="rig"

# --- assemble argv, one element per line (mapfile-safe; no eval, no sourcing) ---
# Start fresh so a stale conf can never leak old args.
: > "$CUSTOM_CONFIG_FILENAME"

emit() { printf '%s\n' "$1" >> "$CUSTOM_CONFIG_FILENAME"; }

# --pool (only when a URL is set; h-run errors clearly if it is missing).
if [[ -n $CUSTOM_URL ]]; then
  emit "--pool"
  emit "$CUSTOM_URL"            # VERBATIM — scheme preserved, no stripping.
fi
# --wallet / --worker
if [[ -n $WALLET ]]; then
  emit "--wallet"
  emit "$WALLET"
fi
emit "--worker"
emit "$WORKER"

# --- Extra config: RAW CLI flags only. A legacy NAME=value env token (CN2=1, POOL_TLS=0, POOL_HOST=...,
# etc.) is REJECTED — those env vars were removed in 2.0.0. We do NOT pass it to the binary as a bogus
# arg; instead we write a sentinel that makes h-run fail pre-flight with a migration message.
if [[ -n $CUSTOM_USER_CONFIG ]]; then
  # Word-split on whitespace/newlines (HiveOS gives a textarea). Pearl flags carry no embedded spaces.
  for tok in $CUSTOM_USER_CONFIG; do
    [[ -z $tok ]] && continue
    # A bare `NAME=value` (letter/underscore-led identifier then `=`, not a `--flag`) is a legacy env
    # line. `--flag=value` starts with `-` and is fine; flag VALUES like `0,1` have no leading NAME=.
    if [[ $tok != -* && $tok =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
      # Sentinel on its own line, the offending token on the next — h-run reads [0]=sentinel,
      # [1..]=token(s) and fails pre-flight with the migration message.
      printf '%s\n%s\n' "__PEARL_LEGACY_ENV__" "$tok" > "$CUSTOM_CONFIG_FILENAME"
      return 0 2>/dev/null || exit 0
    fi
    emit "$tok"
  done
fi
