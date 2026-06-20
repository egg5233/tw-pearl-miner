# tw-pearl-miner

**English** | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md)　·　[Latest release ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)　·　[💬 Discord](https://discord.gg/J6NHCrwmx2)

**Dev fee: 1.5%** (also shown at miner startup).

## Supported pools

- [PearlFortune](https://pearlfortune.org)
- [HeroMiners](https://pearl.herominers.com)
- [AlphaPool](https://alphapool.tech)
- [Kryptex](https://pool.kryptex.com/prl)
- [LuckyPool](https://pearl.luckypool.io/)

## Expected hashrate (*pool-effective *default oc/pl *tested on random vast gpu) 

| 50 | TH/s | 40 | TH/s | 30 | TH/s | DC | TH/s |
|---|---|---|---|---|---|---|---|
| 5090 | 343@575w | 4090 | 295.5@450w | 3090 | 108.6@347w | A100 | 206.1@398w |
| 5080 | 211.1@339w | 4080 | 183@320w | 3080 Ti | 112.6@349w | H100 | 622.7@697w |
| 5070 Ti | 172.1@300w | 4070TS | 157.8@285w | 3080 | 98.5@319w | B200 | 1162@1000w |
| 5070 | 119.2 | 4070 Ti | 143.7 | 3070 Ti | 76.9 |  |  |
| 5060 Ti 16GB | 89.9 | 4070S | 123.1 | 3070 | 72.9 |  |  |
| 5060 Ti 8GB | 81.6 | 4070 | 108.3 | 3060 Ti | 54.7 |  |  |
| 5060 | 71.4 | 4060 Ti | 81.8 |  |  |  |  |
|  |  | 4060 | 55.2 |  |  |  |  |

Models not listed are supported too (Ampere or newer, ≥ 8 GB VRAM); figures to be added. Datacenter figures are for the **SXM** variants — **PCIe** versions run somewhat lower.
**RTX 20-series (Turing)** supported since **v2.0.3** — e.g. RTX 2080 Ti ~59 TH/s. (GTX 16-series has no tensor cores and is not supported.)

| System | NVIDIA driver | Download |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-windows.zip) |
| **Linux** (desktop / server) | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-linux.tar.gz) |
| **Linux** — older driver | 570.26–580 | [tw-pearl-miner-2.1.2-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-2.1.2-cuda12.tar.gz) |
| **HiveOS** — older driver | 570.26–580 | [tw-pearl-miner-2.1.2.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-2.1.2.c12.tar.gz) |

## Quick start

**Linux / HiveOS** 
```
./pearl-gpu-miner --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

**Windows** (in the extracted folder):
```
pearl-gpu-miner.exe --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

Replace YOUR_WALLET with your prl1... payout address; the .worker part is just your rig name.

### Windows
1. Download and extract `tw-pearl-miner-windows.zip`.
2. Edit `start.bat`: set `WALLET` (your `prl1...` address) and `POOL` (your mining pool) — or just run it and type them when asked.
3. Double-click `start.bat`.

###Linux
```
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
```


### HiveOS
Add a Custom Miner with the installation URL from [`hiveos/README.md`](hiveos/README.md). The flight sheet needs a **Pool URL (required, scheme prefix supported)** and your **wallet**; Extra config now takes `--` style arguments . Full instructions there.


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
- `--password <string>` (v2.0.8): stratum password. On **AlphaPool** (`*.alphapool.tech`) this pins static share difficulty via the password field, e.g. `--password 'x;d=65536'`. Other Pearl dialects ignore it.
- `--diff <N>` (v2.0.8): convenience for `--password 'x;d=N'` — pin **AlphaPool** static difficulty to `N` (pool minimum **20000**; `--diff 0` or any non-numeric value is rejected). Recommended on fast cards so the share rate doesn't outrun submission, e.g. a 5090 → `--diff 131072`.
- `--pf` (v2.0.9): treat the pool as **PearlFortune**. PearlFortune is auto-detected from its host (e.g. `--pool jp.pearlfortune.org:8888`); add `--pf` only when connecting through a local forwarder whose address isn't a pearlfortune host.

The miner auto-picks the best matrix shape for your card, prints a periodic hashrate line, mines until you stop it (Ctrl+C), and **auto-reconnects** through pool restarts / network blips / stalled links.

**Requirements**
- **NVIDIA GPU, Ampere or newer** (RTX 30 / 40 / 50, A100, H100). RTX 20-series (Turing, tensor-core) supported since v2.0.3; GTX 16xx (no tensor cores) and pre-Turing not supported.
- **≥ 8 GB VRAM.** 8 GB / 10 GB cards (e.g. 3060 Ti / 3070 / 3080 10G / 4060 Ti 8G / 5060 Ti 8G) **automatically use the low-VRAM mode** since v2.0.1 — no speed penalty; ≥ 12 GB cards are completely unchanged. If VRAM is genuinely insufficient, the miner shows a clear bilingual message and skips the card.
- **NVIDIA driver ≥ 580.65 (Linux) / ≥ 580.88 (Windows)** for the CUDA 13 build, or **≥ 570.26** for the CUDA 12 build. Nothing else to install — the CUDA runtime ships in the bundle.
- The pool connection transport (TLS / plaintext) follows your `--pool` scheme prefix (see the command line above).

> **Driver too old?** If the miner exits immediately with `cudaGetDeviceCount returned 0` or `pk_init failed`, your driver is below the minimum — **update the driver** (a driver-version issue, not a GPU problem), or use the **CUDA 12** download above. Check with `nvidia-smi`.

> **Antivirus false positive?** Some antivirus products (including Windows Defender) may falsely flag the miner — a common false positive for small mining binaries; add the miner folder to your exclusions if it gets quarantined.

</details>

---
Built from the Pearl Rust miner (private source repo). One binary, every supported GPU.
