# tw-pearl-miner on HiveOS

A HiveOS **Custom Miner** package for the Pearl GPU miner. Works on any Ampere-or-newer
NVIDIA GPU (RTX 30/40/50, A100, H100). The pool is built in (`pearl.tw-pool.com:50001`).

## Install

1. In HiveOS, open your worker → **Flight Sheets** → create a new flight sheet (or **Wallets** first).
2. **Add a Custom Miner** (Flight Sheet → Miner → `+` → *Setup Miner Config* → **Custom**):
   - **Miner name:** `tw-pearl-miner`
   - **Installation URL:**
     ```
     https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-1.4.1.tar.gz
     ```
     (if you publish GitHub Releases, you can instead use
     `https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-1.4.1.tar.gz`)
   - **Hash algorithm:** `pearl` (free text — informational only)
3. Fill the flight-sheet fields:
   | Field | Value |
   |-------|-------|
   | **Wallet and worker template** | your `prl1...` payout address |
   | **Pool URL** | *leave blank* (built-in pool) — or `host:port` to override |
   | **Pass** | `x` |
   | **Extra config arguments** | *(optional)* extra env lines, one per line |
4. Apply the flight sheet to the rig. HiveOS downloads the package, installs it to
   `/hive/miners/custom/tw-pearl-miner/`, and starts mining.

The worker name is taken from the rig automatically; hashrate (in TH/s) and accepted/rejected
shares show up on the HiveOS dashboard.

## Package contents
```
tw-pearl-miner/
  pearl-gpu-miner       miner binary (fat: sm_80/86/89/90/120a + PTX)
  libpearlkernel.so     CUDA kernel
  libcudart.so.13       CUDA runtime
  h-manifest.conf       miner metadata
  h-config.sh           builds the run config from the flight sheet
  h-run.sh              launches the miner
  h-stats.sh            reports hashrate/shares to HiveOS
```

## Notes
- **GPU support:** Ampere or newer (needs the SM80 int8 tensor cores). Pre-Ampere (GTX 10xx /
  RTX 20xx) is **not** supported.
- **Driver:** **≥ 580.65** (Linux) — a CUDA 13 capable driver. Update on the rig via the HiveOS web
  UI (worker → ⋮ → *Upgrade* / NVIDIA driver) or Hive Shell `nvidia-driver-update`. If the miner log
  shows `cudaGetDeviceCount returned 0` / `pk_init failed`, the driver is **too old** — `nvidia-smi`
  must report "CUDA Version: 13.0" or higher.
- **Stuck on driver 570–580 (can't reach CUDA 13)?** Use the **CUDA-12.8** custom-miner package as
  your Installation URL instead — same speed, runs on driver ≥ 570.26 (ships `libcudart.so.12`):
  ```
  https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-1.4.1.c12.tar.gz
  ```
- **TLS:** the pool connection is encrypted with TLS.
- **Hashrate units:** the miner's metric is in TH/s; HiveOS displays it scaled (the `total khs`
  field is `TH/s × 1e9`).
