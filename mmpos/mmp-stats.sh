#!/usr/bin/env bash
# tw-pearl-miner — MMPOS stats reporter.
# Args: $1 = device count, $2 = miner log file. Parses pearl-gpu-miner's line output:
#   "<X> TH/s avg"                aggregate hashrate (prefer the cumulative avg)
#   "[gpu0:.. gpu1:.. ]"          optional per-GPU TH/s on multi-GPU rigs
#   "shares: <N> accepted"        accepted tally
#   "<N> rejected"                rejected tally
# and emits the MMPOS JSON: {busid, hash, units, air:[acc,0,rej], miner_name, miner_version}.
DEVICE_COUNT=$1
LOG_FILE=$2
cd "$(dirname "$0")"

if [ -f "mmp-external.conf" ]; then
    . mmp-external.conf
else
    EXTERNAL_NAME="tw-pearl-miner"
    EXTERNAL_VERSION="0"
fi

# NVIDIA (10de) PCI bus ids as decimals, from MMPOS's /run/gpu-info.json or lspci fallback.
get_bus_ids() {
    local vendor_id="$1"
    local gpu_info_json="/run/gpu-info.json"
    local busids=()
    if [[ -f "$gpu_info_json" ]]; then
        local vendor
        vendor_id=$(echo "$vendor_id" | tr -d '[:space:]')
        case "$vendor_id" in
            10de) vendor="nvidia" ;;
            1002) vendor="amd_sysfs" ;;
            *)    vendor="intel_sysfs" ;;
        esac
        local bus_ids
        bus_ids=$(jq -r ".device.GPU.${vendor}_details.busid[]" "$gpu_info_json" 2>/dev/null)
        [[ -z "$bus_ids" ]] && return 1
        while read -r bus_id; do
            local hex=${bus_id:5:2}
            busids+=($((16#$hex)))
        done <<< "$bus_ids"
    else
        local bus_ids
        bus_ids=$(/bin/lspci -n 2>/dev/null | awk '$2 ~ /^030[02]:/ && $3 ~ /^'"$vendor_id"':/ {print $1}')
        [[ -z "$bus_ids" ]] && return 1
        while read -r bus_id; do
            busids+=($((16#${bus_id%%:*})))
        done <<< "$bus_ids"
    fi
    echo "${busids[*]}"
}

strip() { sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'; }   # remove ANSI colour codes

# Aggregate hashrate in TH/s (prefer the stable cumulative avg, fall back to window/total).
ths=$(strip < "$LOG_FILE" 2>/dev/null | grep -oE '[0-9]+(\.[0-9]+)? TH/s avg' | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
[[ -z "$ths" ]] && ths=$(strip < "$LOG_FILE" 2>/dev/null | grep -oE '[0-9]+(\.[0-9]+)? TH/s' | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
[[ -z "$ths" ]] && ths=0

# Accepted / rejected share tallies.
acc=$(strip < "$LOG_FILE" 2>/dev/null | grep -oE 'shares: [0-9]+ accepted' | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z "$acc" ]] && acc=0
rej=$(strip < "$LOG_FILE" 2>/dev/null | grep -oE '[0-9]+ rejected'        | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z "$rej" ]] && rej=0

# GPU count: prefer real NVIDIA bus ids, else the count MMPOS passed, else 1.
read -r -a found <<< "$(get_bus_ids 10de)"
gpu_count=${#found[@]}
[[ $gpu_count -eq 0 && "$DEVICE_COUNT" =~ ^[0-9]+$ && $DEVICE_COUNT -gt 0 ]] && gpu_count=$DEVICE_COUNT
[[ $gpu_count -eq 0 ]] && gpu_count=1

# Per-GPU TH/s from "[gpu0:.. gpu1:..]" when present and the count matches; else split the aggregate.
per=$(strip < "$LOG_FILE" 2>/dev/null | grep -oE '\[gpu0:[0-9].*\]' | tail -1 | grep -oE 'gpu[0-9]+:[0-9]+(\.[0-9]+)?' | grep -oE '[0-9]+(\.[0-9]+)?$')
pn=$(printf '%s\n' "$per" | grep -c .)
hash=()
if [[ -n "$per" && $pn -eq $gpu_count ]]; then
    while read -r v; do
        [[ -z "$v" ]] && continue
        hash+=($(awk -v x="$v" 'BEGIN{ printf "%.0f", x*1000 }'))   # TH/s -> GH/s
    done <<< "$per"
else
    each=$(awk -v t="$ths" -v n="$gpu_count" 'BEGIN{ printf "%.0f", (n>0? t/n : t)*1000 }')
    for ((j=0; j<gpu_count; j++)); do hash+=("$each"); done
fi

# Bus-id array aligned to gpu_count (0-fill if the OS gave us none).
busid=()
if [[ ${#found[@]} -gt 0 ]]; then
    for ((j=0; j<gpu_count; j++)); do busid+=("${found[$j]:-0}"); done
else
    for ((j=0; j<gpu_count; j++)); do busid+=(0); done
fi

jq -nc \
    --argjson hash  "$(printf '%s\n' "${hash[@]}"  | jq -cs .)" \
    --argjson busid "$(printf '%s\n' "${busid[@]}" | jq -cs .)" \
    --arg acc "${acc:-0}" \
    --arg rej "${rej:-0}" \
    --arg units "ghs" \
    --arg miner_name "$EXTERNAL_NAME" \
    --arg miner_version "$EXTERNAL_VERSION" \
    '{
        $busid,
        $hash,
        $units,
        air: [($acc|tonumber), 0, ($rej|tonumber)],
        miner_name: $miner_name,
        miner_version: $miner_version
    }'
