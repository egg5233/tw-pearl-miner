#!/usr/bin/env bash
# Report hashrate + GPU stats to HiveOS. Sourced by the agent: it reads $khs and $stats.
# The miner prints aggregate "<X> TH/s avg" lines; we parse the latest and convert TH/s -> kH/s.

. h-manifest.conf 2>/dev/null
LOG="${CUSTOM_LOG_BASENAME}.log"

# latest aggregate hashrate in TH/s (prefer the stable cumulative avg, fall back to window)
ths=$(grep -oE '[0-9]+(\.[0-9]+)? TH/s avg' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?')
[[ -z $ths ]] && ths=$(grep -oE '[0-9]+(\.[0-9]+)? TH/s' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?')
[[ -z $ths ]] && ths=0

# TH/s -> kH/s   (1 TH/s = 1e9 kH/s)
khs=$(awk -v t="$ths" 'BEGIN{ printf "%.0f", t*1000000000 }')

# accepted / rejected from the share tally
acc=$(grep -oE 'shares: [0-9]+ accepted' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z $acc ]] && acc=0
rej=$(grep -oE '[0-9]+ rejected'        "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z $rej ]] && rej=0

# GPU temps / fans / bus ids from the HiveOS agent (degrade gracefully if absent)
gpu_json=$(cat /run/hive/gpu-stats.json 2>/dev/null)
temp='[]'; fan='[]'; bus='[]'; gpu_count=1
if [[ -n $gpu_json ]] && command -v jq >/dev/null 2>&1; then
  temp=$(echo "$gpu_json" | jq -c '[.temp[]?]' 2>/dev/null);  [[ -z $temp || $temp == null ]] && temp='[]'
  fan=$(echo  "$gpu_json" | jq -c '[.fan[]?]'  2>/dev/null);  [[ -z $fan  || $fan  == null ]] && fan='[]'
  bus=$(echo  "$gpu_json" | jq -c '[.busids[]?]' 2>/dev/null); [[ -z $bus  || $bus  == null ]] && bus='[]'
  n=$(echo "$temp" | jq 'length' 2>/dev/null); [[ -n $n && $n -gt 0 ]] && gpu_count=$n
fi

# the miner reports one aggregate number; split it evenly so HiveOS shows per-GPU bars
hs_each=$(awk -v k="$khs" -v n="$gpu_count" 'BEGIN{ printf "%.0f", (n>0)? k/n : k }')
hs=$(awk -v e="$hs_each" -v n="$gpu_count" 'BEGIN{ printf "["; for(i=0;i<n;i++){ printf "%s%s", (i?",":""), e } printf "]" }')

uptime=$(awk '{print int($1)}' /proc/uptime 2>/dev/null); [[ -z $uptime ]] && uptime=0

stats=$(cat <<EOF
{"hs":$hs,"hs_units":"khs","temp":$temp,"fan":$fan,"bus_numbers":$bus,"uptime":$uptime,"ver":"$CUSTOM_VERSION","ar":[$acc,$rej],"algo":"pearl"}
EOF
)

# $khs and $stats are read by the HiveOS agent.
[[ $khs == 0 ]] && stats=""
