#!/usr/bin/env bash
# Report hashrate + GPU stats to HiveOS. Sourced by the agent: it reads $khs and $stats.
# The miner prints aggregate "<X> TH/s avg" lines plus an optional per-GPU "[gpu0:.. gpu1:..]"
# suffix; we parse the latest line and convert TH/s -> kH/s.

# Resolve OUR OWN directory and source the manifest from there. The agent sources this file by
# absolute path and does NOT guarantee a particular CWD, so a relative `. h-manifest.conf` can
# silently fail -> CUSTOM_LOG_BASENAME unset -> LOG=./.log -> khs=0 -> empty dashboard bars.
# When a file is *sourced*, $0 is the parent shell; BASH_SOURCE[0] is this file.
HS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
. "$HS_DIR/h-manifest.conf" 2>/dev/null
# Hard fallback to the standard install path so stats work no matter what the agent sets.
[[ -z $CUSTOM_LOG_BASENAME ]] && CUSTOM_LOG_BASENAME=/var/log/miner/tw-pearl-miner/tw-pearl-miner
[[ -z $CUSTOM_VERSION ]] && CUSTOM_VERSION=0
LOG="${CUSTOM_LOG_BASENAME}.log"

# latest aggregate hashrate in TH/s (prefer the stable cumulative avg, fall back to window/total)
ths=$(grep -oE '[0-9]+(\.[0-9]+)? TH/s avg' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
[[ -z $ths ]] && ths=$(grep -oE '[0-9]+(\.[0-9]+)? TH/s' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
[[ -z $ths ]] && ths=0

# TH/s -> kH/s   (1 TH/s = 1e9 kH/s)
khs=$(awk -v t="$ths" 'BEGIN{ printf "%.0f", t*1000000000 }')

# accepted / rejected from the share tally
acc=$(grep -oE 'shares: [0-9]+ accepted' "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z $acc ]] && acc=0
rej=$(grep -oE '[0-9]+ rejected'        "$LOG" 2>/dev/null | tail -1 | grep -oE '[0-9]+' | head -1); [[ -z $rej ]] && rej=0

# ---------------------------------------------------------------------------
# GPU temps / fans / bus ids from the HiveOS agent — NVIDIA CARDS ONLY.
#
# Two dashboard-killing gotchas handled here (the "8 empty rectangles" bug):
#  1. gpu-stats.json includes integrated graphics (Intel/AMD iGPU, brand!="nvidia").
#     Including it makes our array lengths disagree with the miner's per-GPU count,
#     and gives HiveOS a bus number that isn't a mining card.
#  2. HiveOS maps hs[] entries onto card boxes via INTEGER bus numbers ([1,3,9,10...]),
#     but gpu-stats.json busids are strings like "01:00.0" (PCI hex). We must take the
#     bus part and convert hex -> decimal ("0a" -> 10), or the mapping silently fails
#     and every per-card box shows empty.
# ---------------------------------------------------------------------------
GPU_STATS_JSON=${GPU_STATS_JSON:-/run/hive/gpu-stats.json}
gpu_json=$(cat "$GPU_STATS_JSON" 2>/dev/null)
temp='[]'; fan='[]'; bus='[]'; gpu_count=0
if [[ -n $gpu_json ]] && command -v jq >/dev/null 2>&1; then
  # Indices of NVIDIA entries. Older agents may lack the brand array -> fall back to all entries.
  nv_idx=$(echo "$gpu_json" | jq -r '(.brand // []) | to_entries[] | select(.value=="nvidia") | .key' 2>/dev/null)
  [[ -z $nv_idx ]] && nv_idx=$(echo "$gpu_json" | jq -r '(.busids // []) | to_entries[] | .key' 2>/dev/null)
  t_arr=''; f_arr=''; b_arr=''; sep=''
  for i in $nv_idx; do
    t=$(echo "$gpu_json" | jq -r ".temp[$i] // 0" 2>/dev/null);   [[ $t =~ ^[0-9]+(\.[0-9]+)?$ ]] || t=0
    f=$(echo "$gpu_json" | jq -r ".fan[$i] // 0" 2>/dev/null);    [[ $f =~ ^[0-9]+(\.[0-9]+)?$ ]] || f=0
    bhex=$(echo "$gpu_json" | jq -r ".busids[$i] // \"00\"" 2>/dev/null | cut -d: -f1)
    [[ $bhex =~ ^[0-9a-fA-F]+$ ]] || bhex=00
    b=$((16#$bhex))   # PCI bus is hex: "0a:00.0" -> 10
    t_arr+="$sep$t"; f_arr+="$sep$f"; b_arr+="$sep$b"; sep=','
    gpu_count=$((gpu_count+1))
  done
  if [[ $gpu_count -gt 0 ]]; then
    temp="[$t_arr]"; fan="[$f_arr]"; bus="[$b_arr]"
  fi
fi

# Per-GPU hashrate: on multi-GPU rigs the miner appends "[gpu0:69 gpu1:68 ...]" (TH/s). Use those
# real numbers when their count matches the rig's NVIDIA count; otherwise split the aggregate evenly.
per_vals=$(grep -oE '\[gpu0:[0-9].*\]' "$LOG" 2>/dev/null | tail -1 \
            | grep -oE 'gpu[0-9]+:[0-9]+(\.[0-9]+)?' | grep -oE '[0-9]+(\.[0-9]+)?$')
pn=$(printf '%s\n' "$per_vals" | grep -c .)
if [[ -n $per_vals && ( $gpu_count -eq 0 || $pn -eq $gpu_count ) ]]; then
  hs=$(printf '%s\n' "$per_vals" | awk 'BEGIN{printf "["} {printf "%s%.0f",(NR>1?",":""),$1*1000000000} END{printf "]"}')
  [[ $gpu_count -eq 0 ]] && gpu_count=$pn
else
  [[ $gpu_count -eq 0 ]] && gpu_count=1
  hs_each=$(awk -v k="$khs" -v n="$gpu_count" 'BEGIN{ printf "%.0f", (n>0)? k/n : k }')
  hs=$(awk -v e="$hs_each" -v n="$gpu_count" 'BEGIN{ printf "["; for(i=0;i<n;i++){ printf "%s%s", (i?",":""), e } printf "]" }')
fi

uptime=$(awk '{print int($1)}' /proc/uptime 2>/dev/null); [[ -z $uptime ]] && uptime=0

stats=$(cat <<EOF
{"hs":$hs,"hs_units":"khs","temp":$temp,"fan":$fan,"bus_numbers":$bus,"uptime":$uptime,"ver":"$CUSTOM_VERSION","ar":[$acc,$rej],"algo":"pearl"}
EOF
)

# $khs and $stats are read by the HiveOS agent.
[[ $khs == 0 ]] && stats=""
