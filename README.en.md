# tw-pearl-miner

**English** | [简体中文](README.md) | [繁體中文](README.zh-TW.md)　·　[Latest release ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)

Pre-built GPU miner for the **Pearl** pool (`pearl.tw-pool.com:50001`, built in) — one binary for any **Ampere-or-newer NVIDIA GPU** (RTX 30 / 40 / 50, A100, H100) on **Windows · Linux · HiveOS**. Pre-Ampere (GTX 10xx / RTX 20xx) is not supported.

> **Latest (v1.4.4):** username mining now accepts a worker name — `pearl-gpu-miner -u <username>.<worker>` (e.g. `-u egg5233.my_rig`), the same `name.worker` form `--wallet` already supports (v1.4.3 rejected it as "invalid username"). Plain `-u <username>` and `--wallet <prl1…>` are unchanged. [Full changelog ↗](https://github.com/egg5233/tw-pearl-miner/releases)

## Download

**Two questions:**

1. **What are you running?** — Windows, Linux (desktop / server), or HiveOS.
2. **NVIDIA driver version?** — run `nvidia-smi`: **≥ 580.65** → normal **CUDA 13** build · **570.26–580** → **CUDA 12** build (`-cuda12` / `.c12`) · **< 570.26** → update your driver first.

| Your setup | NVIDIA driver | Download |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-windows.zip) |
| **Linux** (desktop / server) | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-linux.zip) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-1.4.4.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-1.4.4.tar.gz) |
| **Linux** — older driver | 570.26–580 | [tw-pearl-miner-1.4.4-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-1.4.4-cuda12.tar.gz) |
| **HiveOS** — older driver | 570.26–580 | [tw-pearl-miner-1.4.4.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-1.4.4.c12.tar.gz) |

> `.tar.gz` / `.zip` (Linux) = the **same build**, different archive format. The `cuda12` / `.c12` builds are **identical in speed and features** — only the bundled CUDA runtime differs, so they start on older (≥ 570.26) drivers. Use them only if the normal build exits with `cudaGetDeviceCount returned 0` / `pk_init failed`. Verify any download with [`SHA256SUMS`](SHA256SUMS): `sha256sum -c SHA256SUMS`.

## Quick start

### Windows
1. Download and extract `tw-pearl-miner-windows.zip`.
2. Edit `start.bat` and set your `WALLET` (your `prl1...` address) — or just run it and paste the address when asked.
3. Double-click `start.bat`.

### Linux
> ⚠️ Download with the table links or the `wget`/`curl` below — do **not** open the file on github.com and "Save As" (that saves the *web page* as HTML, which can't be extracted — the #1 cause of "can't unzip").

```bash
# one-line install — downloads, extracts, prompts for wallet, runs
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ...or manually (.tar.gz or .zip — same files):
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.4/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # set WALLET=your prl1... address
bash start.sh          # optional: bash start.sh <worker-name>
```

### HiveOS
Add a Custom Miner with the installation URL from [`hiveos/README.md`](hiveos/README.md) and set your wallet in the flight sheet. Full instructions there.

<details>
<summary><b>Expected hashrate</b> — RTX 30 / 40 / 50, A100, H100</summary>

Approximate Pearl hashrate per card at **stock clocks** (the miner auto-selects the best shape per GPU). Power-limit / OC tuning can add a few %; actual results vary by host and cooling.

| RTX 50 (Blackwell) | TH/s | RTX 40 (Ada) | TH/s | Datacenter | TH/s |
|---|---|---|---|---|---|
| RTX 5090 | ~325 | RTX 4090 | ~250 | H100 SXM | ~625 |
| RTX 5080 | ~188 | RTX 4080 | ~160 *(est.)* | A100 SXM4 40 GB | ~142 |
| RTX 5070 Ti | ~157 | RTX 4070 Ti | ~133 | | |
| RTX 5070 | ~111 | RTX 4070 | ~102 | | |
| RTX 5060 Ti | ~76 | RTX 4060 Ti | ~69 | | |
| RTX 5060 | ~63 | | | | |

Datacenter figures are for the **SXM** variants — **PCIe** versions run somewhat lower.

</details>

<details>
<summary><b>All options &amp; requirements</b></summary>

**Command line**
```
pearl-gpu-miner --wallet <prl1...address> [--worker <name>] [--gpus 0,1]
pearl-gpu-miner -u <username>[.<worker>]  [--gpus 0,1]
```
- `--wallet` (required): your payout address.
- `-u <username>`: mine with your pool username instead of `--wallet` (set your payout address on the pool website first; the pool resolves the username to your address). Use exactly one of `--wallet` or `-u`. You can append a worker name as `-u <username>.<worker>` (e.g. `-u egg5233.my_rig`) — equivalent to `-u <username> --worker <worker>`.
- `--worker` (default: machine name): rig name shown on the pool.
- `--gpus` (default: all): comma-separated device ids, e.g. `0,1,2,3`.

The miner auto-picks the best matrix shape for your card, prints a periodic hashrate line, mines until you stop it (Ctrl+C), and **auto-reconnects** through pool restarts / network blips / stalled links.

**Requirements**
- **NVIDIA GPU, Ampere or newer** (RTX 30 / 40 / 50, A100, H100). Pre-Ampere (GTX 10xx / RTX 20xx) not supported.
- **NVIDIA driver ≥ 580.65 (Linux) / ≥ 580.88 (Windows)** for the CUDA 13 build, or **≥ 570.26** for the CUDA 12 build. Nothing else to install — the CUDA runtime ships in the bundle.
- The pool connection is encrypted with **TLS**.

> **Driver too old?** If the miner exits immediately with `cudaGetDeviceCount returned 0` or `pk_init failed`, your driver is below the minimum — **update the driver** (a driver-version issue, not a GPU problem), or use the **CUDA 12** download above. Check with `nvidia-smi`.

</details>

---
Built from the Pearl Rust miner (private source repo). One binary, every supported GPU.
