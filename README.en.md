# tw-pearl-miner

**English** | [简体中文](README.md) | [繁體中文](README.zh-TW.md)

Pre-built GPU miner for the **Pearl** pool (`pearl.tw-pool.com:50001`, built in).
Windows + Linux binaries, plus a HiveOS custom-miner package.

One fat binary runs on **any Ampere-or-newer NVIDIA GPU** — RTX 30 / 40 / 50 series, A100,
H100 (native SASS for sm_80/86/89/90/120a + a PTX fallback). Pre-Ampere (GTX 10xx / RTX 20xx)
is not supported.

## What's new in v1.4.1
- **Auto-recovery on stalled connections.** If the link to the pool silently stalls — your rig keeps hashing at full speed, but the **pool/dashboard hashrate drops toward 0** because shares stop reaching the pool — the miner now **detects the stalled link within ~15 seconds and automatically reconnects**, instead of hanging until you restart it. Much more reliable on unstable or restrictive networks. (Windows, Linux, and HiveOS.)

## What's new in v1.4.0
- **Version on startup.** The miner now prints `tw-pearl-miner v1.4.0` when it launches, so you always know which version you're running.
- **More reliable share submission.**

## What's new in v1.3.9.1
- **Fixes an 8-card / many-GPU rig hang** (CPU busy-spin on GPU sync caused a load spike). **Multi-GPU rig users: update to v1.3.9.1.** Single / desktop GPU users are unaffected (update optional). *(Windows binary is unchanged from v1.3.9 — the hang only affects multi-GPU Linux/HiveOS rigs.)*

## What's new in v1.3.9
- RTX 5090 mining path optimized (**+2–4%** on accepted shares).
- **H100 / H200 / datacenter cards now mine correctly** — they were previously 100% rejected; H100 now does **~625 TH/s**.
- HiveOS: **per-GPU hashrate now shows on the dashboard** (was: total only).

## Which file do I download?

**Two questions:**

1. **What are you running?** — Windows, Linux (desktop/server), or a HiveOS rig.
2. **How new is your NVIDIA driver?** — run `nvidia-smi` and read the driver version:
   - **≥ 580.65** → the normal **CUDA 13** build (below).
   - **570.26 – 580** → the **CUDA 12** build (`-cuda12` / `.c12`) — same speed and features, it just starts on older drivers.
   - **< 570.26** → update your driver, then use the normal build.

| Your setup | NVIDIA driver | Download |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-windows.zip) |
| **Linux** (desktop / server) | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-linux.zip) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-1.4.1.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-1.4.1.tar.gz) |
| **Linux** — older driver | 570.26 – 580 | [tw-pearl-miner-1.4.1-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-1.4.1-cuda12.tar.gz) |
| **HiveOS** — older driver | 570.26 – 580 | [tw-pearl-miner-1.4.1.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-1.4.1.c12.tar.gz) |

- **`.tar.gz` vs `.zip`** (Linux) = the **same build**, just two archive formats — pick whichever you can extract.
- **CUDA 12 builds** (`-cuda12`, `.c12`) are **identical in speed and features** — only the bundled CUDA runtime differs, so they start on **older drivers (≥ 570.26)**. Use them only if the normal build exits with `cudaGetDeviceCount returned 0` / `pk_init failed`.

Verify with [`SHA256SUMS`](SHA256SUMS): `sha256sum -c SHA256SUMS`.

## Quick start

### Windows
1. Download and extract `tw-pearl-miner-windows.zip`.
2. Edit `start.bat` and set your `WALLET` (your `prl1...` address) — or just run it and paste the address when asked.
3. Double-click `start.bat`.

> ⚠️ **Download with a command or the table links above — do NOT open the file on github.com and "Save As"** (that saves the *web page* as HTML, which can't be extracted — the #1 cause of "can't unzip"). The `wget`/`curl` commands below fetch the real file.

One-line install (does everything):
```bash
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
```
Or download + extract manually (two formats, same files — pick one):
```bash
# .tar.gz
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux

# ...or .zip
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.1/tw-pearl-miner-linux.zip
unzip tw-pearl-miner-linux.zip && cd tw-pearl-miner-linux
```
Then set your wallet and run:
```bash
nano start.sh          # set WALLET=your prl1... address
bash start.sh          # optional: bash start.sh <worker-name>
```

### HiveOS
Add a Custom Miner with the installation URL from [`hiveos/README.md`](hiveos/README.md) and set your
wallet in the flight sheet. Full instructions there.

## Expected hashrate

Approximate Pearl hashrate per card, at the shape the miner auto-selects for that GPU (stock clocks):

**GeForce RTX 50 (Blackwell)**

| GPU | Pearl hashrate |
|-----|----------------|
| RTX 5090 | ~325 TH/s |
| RTX 5080 | ~188 TH/s |
| RTX 5070 Ti | ~157 TH/s |
| RTX 5070 | ~111 TH/s |
| RTX 5060 Ti | ~76 TH/s |
| RTX 5060 | ~63 TH/s |

**GeForce RTX 40 (Ada)**

| GPU | Pearl hashrate |
|-----|----------------|
| RTX 4090 | ~250 TH/s |
| RTX 4080 | ~160 TH/s *(est.)* |
| RTX 4070 Ti | ~133 TH/s |
| RTX 4070 | ~102 TH/s |
| RTX 4060 Ti | ~69 TH/s |

**Datacenter**

| GPU | Pearl hashrate |
|-----|----------------|
| H100 SXM | ~625 TH/s |
| A100 SXM4 (40 GB) | ~142 TH/s |

> Measured on the Pearl pool at **stock clocks**; power-limit / OC tuning can add a few %, and actual
> results vary by host and cooling. Datacenter figures are for the **SXM** variants — **PCIe** versions
> run somewhat lower.

## Usage

```
pearl-gpu-miner --wallet <prl1...address> [--worker <name>] [--gpus 0,1]
```
- `--wallet` (required): your payout address.
- `--worker` (default: machine name): rig name shown on the pool.
- `--gpus` (default: all): comma-separated device ids, e.g. `0,1,2,3`.

The miner automatically picks the best matrix shape for your card, shows a periodic hashrate
line, mines until you stop it (Ctrl+C), and auto-reconnects through pool restarts / network blips.

### Requirements
- **NVIDIA GPU, Ampere or newer** (RTX 30 / 40 / 50, A100, H100). Pre-Ampere (GTX 10xx / RTX 20xx) is not supported.
- **NVIDIA driver ≥ 580.65 (Linux) / ≥ 580.88 (Windows)** — a CUDA 13 capable driver. *Newer is always fine; the simplest is to install the latest.*
- Nothing else to install — the CUDA runtime ships in the bundle.

> **Driver too old?** If the miner exits right away with `cudaGetDeviceCount returned 0` or
> `pk_init failed`, your driver is below the minimum above — **update the driver** (this is a driver
> version issue, not a GPU problem). Check yours with `nvidia-smi`; the "CUDA Version" shown must be
> **13.0 or higher**.

### Connection / TLS
The pool connection is encrypted with **TLS**.

---
Built from the Pearl Rust miner (private source repo). One binary, every supported GPU.
