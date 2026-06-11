# tw-pearl-miner

**English** | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md)　·　[Latest release ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)

**A general-purpose miner since v2.0.0** — no built-in pool; it connects to any Pearl pool you choose (`--pool` is required).
**Dev fee: 1.5%** (also shown at miner startup).

| System | NVIDIA driver | Download |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-windows.zip) |
| **Linux** (desktop / server) | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-linux.tar.gz) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-2.0.2.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-2.0.2.tar.gz) |
| **Linux** — older driver | 570.26–580 | [tw-pearl-miner-2.0.2-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-2.0.2-cuda12.tar.gz) |
| **HiveOS** — older driver | 570.26–580 | [tw-pearl-miner-2.0.2.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-2.0.2.c12.tar.gz) |

## Quick start

### Windows
1. Download and extract `tw-pearl-miner-windows.zip`.
2. Edit `start.bat`: set `WALLET` (your `prl1...` address) and `POOL` (your mining pool) — or just run it and type them when asked.
3. Double-click `start.bat`.

```bash
# one-line install — downloads and extracts
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ...or manually:
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.2/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # set WALLET=your prl1... address, POOL=your mining pool
bash start.sh          # optional: bash start.sh <worker-name>
```

### HiveOS
Add a Custom Miner with the installation URL from [`hiveos/README.md`](hiveos/README.md). The flight sheet needs a **Pool URL (required, scheme prefix supported)** and your **wallet**; Extra config now takes `--` style arguments (the 1.x `CN2=1` / `POOL_TLS=0` env-var style is gone — migration notes in that document). Full instructions there.

<details>
<summary><b>Expected hashrate</b> — RTX 30 / 40 / 50, A100, H100</summary>

Approximate Pearl hashrate per card at **stock clocks** (the miner auto-selects the best shape per GPU). Power-limit / OC tuning can add a few %; **actual figures vary by pool / difficulty**, host and cooling.

| RTX 50 (Blackwell) | TH/s | RTX 40 / 30 | TH/s | Datacenter | TH/s |
|---|---|---|---|---|---|
| RTX 5090 | testing | RTX 4090 | 289 | A100 SXM4 40 GB | 164.8 |
| RTX 5080 | 198.1 | RTX 4080 | 176.2 | H100 SXM | 134.7 |
| RTX 5070 Ti | 167.7 | RTX 3090 | 108.7 | | |
| RTX 5070 | 118.4 | | | | |
| RTX 5060 8G | ~70 | | | | |

Models not listed are supported too (Ampere or newer, ≥ 8 GB VRAM); figures to be added. Datacenter figures are for the **SXM** variants — **PCIe** versions run somewhat lower.

</details>

<details>
<summary><b>All options &amp; requirements</b></summary>

**Command line**
```
pearl-gpu-miner --pool <pool> --wallet <prl1...address> [--worker <name>] [--gpus 0,1]
```
- `--pool` (required): your mining pool. Accepted forms:
  - `host:port` — **transport auto-detected** (since v2.0.2 this works for ANY pool: the miner probes TLS vs plaintext at startup, no scheme needed; e.g. `hk.pearl.herominers.com:1200`).
  - `stratum+ssl://host:port` — TLS with certificate verification.
  - `stratum+tcp://host:port` — plaintext.
  - `stratum+ssl-insecure://host:port` — TLS without certificate verification (relays / direct-IP connections).
- `--wallet` (required): your payout address.
- `--worker` (default: machine name): rig name shown on the pool.
- `--gpus` (default: all): comma-separated device ids, e.g. `0,1,2,3`.
- `--low-vram` (v2.0.2): force the low-VRAM mode on every GPU (frees ~8 GB with no speed change; 8–10 GB cards already enable it automatically). Useful on shared-GPU rigs.
- `--no-tui` (v2.0.2): use the classic single-line output. A full-screen UI (live per-card hashrate, temps, shares and a log panel) is enabled automatically in an interactive terminal; redirected / scripted / HiveOS environments fall back to line mode automatically.

The miner auto-picks the best matrix shape for your card, prints a periodic hashrate line, mines until you stop it (Ctrl+C), and **auto-reconnects** through pool restarts / network blips / stalled links.

**Requirements**
- **NVIDIA GPU, Ampere or newer** (RTX 30 / 40 / 50, A100, H100). Pre-Ampere (GTX 10xx / RTX 20xx) not supported.
- **≥ 8 GB VRAM.** 8 GB / 10 GB cards (e.g. 3060 Ti / 3070 / 3080 10G / 4060 Ti 8G / 5060 Ti 8G) **automatically use the low-VRAM mode** since v2.0.1 — no speed penalty; ≥ 12 GB cards are completely unchanged. If VRAM is genuinely insufficient, the miner shows a clear bilingual message and skips the card.
- **NVIDIA driver ≥ 580.65 (Linux) / ≥ 580.88 (Windows)** for the CUDA 13 build, or **≥ 570.26** for the CUDA 12 build. Nothing else to install — the CUDA runtime ships in the bundle.
- The pool connection transport (TLS / plaintext) follows your `--pool` scheme prefix (see the command line above).

> **Driver too old?** If the miner exits immediately with `cudaGetDeviceCount returned 0` or `pk_init failed`, your driver is below the minimum — **update the driver** (a driver-version issue, not a GPU problem), or use the **CUDA 12** download above. Check with `nvidia-smi`.

> **Antivirus false positive?** Some antivirus products (including Windows Defender) may falsely flag the miner — a common false positive for small mining binaries; add the miner folder to your exclusions if it gets quarantined.

</details>

---
Built from the Pearl Rust miner (private source repo). One binary, every supported GPU.
