#!/usr/bin/env bash
# tw-pearl-miner — MMPOS launcher.
# MMPOS calls this with generic flags (--pool/--user/--password/--devices/--api-port/--algo). We map
# them to pearl-gpu-miner's own CLI and exec it. Any EXTRA flags from the MMPOS "Extra config" field
# pass through verbatim, so you can add e.g.  --rank 512   --intensity 2   --gpus 0,1   --shape 65536x65536.
cd "$(dirname "$0")"
MINER_DIR="$(pwd)"
EXEC="./pearl-gpu-miner"
CONF_FILE="mmp-external.conf"
trap 'while killall pearl-gpu-miner >/dev/null 2>&1; do sleep 1; done; exit 0' SIGTERM

ARGS=("$@"); FINAL_ARGS=()
POOL_VAL=""; USER_VAL=""; PASS_VAL=""; DEVICES_VAL=""; API_PORT=4444

i=0
while [[ $i -lt ${#ARGS[@]} ]]; do
    case "${ARGS[$i]}" in
        --pool)     POOL_VAL="${ARGS[$((i+1))]}";    ((i+=2)) ;;
        --user)     USER_VAL="${ARGS[$((i+1))]}";    ((i+=2)) ;;
        --password) PASS_VAL="${ARGS[$((i+1))]}";    ((i+=2)) ;;
        --devices)  DEVICES_VAL="${ARGS[$((i+1))]}"; ((i+=2)) ;;
        --api-port) API_PORT="${ARGS[$((i+1))]}";    ((i+=2)) ;;
        --algo)     ((i+=2)) ;;   # pearl is single-algorithm; ignore
        *)          FINAL_ARGS+=("${ARGS[$i]}"); ((i+=1)) ;;
    esac
done

# Persist the API port for MMPOS bookkeeping. (pearl stats are log-based; mmp-stats.sh does not use it.)
[[ -z "$API_PORT" || "$API_PORT" == "0" ]] && API_PORT=4444
if grep -q '^CUSTOM_API_PORT=' "$CONF_FILE" 2>/dev/null; then
    sed -i "s/^CUSTOM_API_PORT=.*/CUSTOM_API_PORT=$API_PORT/" "$CONF_FILE"
else
    echo "CUSTOM_API_PORT=$API_PORT" >> "$CONF_FILE"
fi

# GPU selection: MMPOS --devices -> CUDA_VISIBLE_DEVICES (universal; pearl honors it).
if [[ -n "$DEVICES_VAL" ]]; then
    export CUDA_VISIBLE_DEVICES="$DEVICES_VAL"
    echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"
fi

# Split the MMPOS user "address.worker" into pearl's --wallet + --worker.
if [[ "$USER_VAL" == *.* ]]; then
    WALLET="${USER_VAL%%.*}"
    WORKER="${USER_VAL#*.}"
else
    WALLET="$USER_VAL"
    WORKER="mmpos"
fi

CMD=( "$EXEC" )
# Pool value is passed AS-IS. pearl-gpu-miner auto-detects TLS vs plaintext from host:port AND honors
# an explicit scheme (stratum+ssl:// / stratum+ssl-insecure:// / stratum+tcp://). Do NOT force a scheme
# here — forcing stratum+tcp:// would break TLS-only pools (e.g. herominers :1200).
[[ -n "$POOL_VAL" ]] && CMD+=( --pool "$POOL_VAL" )
[[ -n "$WALLET" ]]   && CMD+=( --wallet "$WALLET" )
[[ -n "$WORKER" ]]   && CMD+=( --worker "$WORKER" )
[[ -n "$PASS_VAL" ]] && CMD+=( --password "$PASS_VAL" )
CMD+=( --no-tui )                # force classic line output so mmp-stats.sh can parse the log
CMD+=( "${FINAL_ARGS[@]}" )      # pass-through extras (--rank / --intensity / --gpus / --shape / ...)

# pearl-gpu-miner loads libpearlkernel.so + libcudart from its own dir.
export LD_LIBRARY_PATH="$MINER_DIR:${LD_LIBRARY_PATH:-}"

echo "Running: ${CMD[*]}"
exec "${CMD[@]}" 2>&1
