# tw-pearl-miner

**English** | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md)　·　[Latest release ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)　·　[💬 Discord](https://discord.gg/J6NHCrwmx2)

**Dev fee: 1.5%** (also shown at miner startup).

## Expected hashrate (*pool-effective *default oc/pl *tested on random vast gpu) RANK 128

| 50 | TH/s | 40 | TH/s | 30 | TH/s | DC | TH/s |
|---|---|---|---|---|---|---|---|
| 5090 | 348.8†@600w | 4090 | 266.5†@450w | 3090 | TBD | A100 | 202.5†@400w |
| 5090 | 330@505w | 4080S | 189.6@320w | 3080Ti | TBD | H100 | 582.4†@700w |
| 5080 | 185.5†@360w | 4080 | 185.0@319w | 3080 | TBD | B200 | 893.5†@1000w |
| 5070Ti | 194.9†@300w | 4070TS | 158.2@285w | 3070Ti | TBD | PRO6000 | 356.3†@600w |
| 5070 | 124@250w | 4070Ti | 151.1@285w | 3070 | TBD |  |  |
| 5060Ti | 110.6†@180w | 4070S | 129.4@220w | 3060Ti | TBD |  |  |
| 5060 | 74.7@155w | 4070 | 114.5@200w | 3060 | TBD |  |  |
|  | | 4060Ti | 79.6@165w |  |  |  |  |
|  |  | 4060 | 56.4@115w |  |  |  |  |

† **Credited (pool-effective) rate of the shipped v3.5.1**, measured on a rented stock card on
kryptex, 2026-10-22. Credited = difficulty of accepted shares ÷ window time, so it already carries
stale/reject loss. Power is the limit actually applied during the run. Rows **without** † are
earlier figures of mixed basis — some of them are the miner's own *displayed* rate, which runs up to
~12 % above credited — and are being re-measured.

| † card | Credited TH/s | Applied power / stock TDP | Accepted shares | 95 % CI (Poisson, our share count only) |
|---|---:|---|---:|---:|
| RTX 5090 | 348.8 | 600 W / 575 W (box board default was 600 W) | 395 | ±9.9 % |
| RTX 4090 | 266.5 | 450 W / 450 W | 302 | ±11.3 % |
| RTX 5080 | 185.5 | 360 W / 360 W | 99 | ±19.7 % |
| RTX 5070 Ti | 194.9 | 300 W / 300 W | 104 | ±19.2 % |
| RTX 5060 Ti | 110.6 | 180 W / 180 W | 59 | ±25.5 % |
| A100 SXM4 | 202.5 | 400 W / 400 W | 108 | ±18.9 % |
| H100 SXM | 582.4 | 700 W / 700 W | 660 | ±7.6 % |
| B200 | 893.5 | 1000 W / 1000 W | 1012 | ±6.2 % |
| RTX PRO 6000 WS | 356.3 | 600 W / 600 W | 95 | ±20.1 % |

The CI is Poisson on our own accepted-share count (±1.96/√N) and does **not** cover across-leg drift,
host variation or thermals. Single rented sample per card; your rig will differ.


## Download
(https://github.com/egg5233/tw-pearl-miner/releases/)

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
- `--no-tui` (v2.0.2): use the classic single-line output. A full-screen UI (live per-card hashrate, temps, shares and a log panel) is enabled automatically in an interactive terminal; redirected / scripted / HiveOS environments fall back to line mode automatically.
- `--password <string>` (v2.0.8): stratum password. On **AlphaPool** (`*.alphapool.tech`) this pins static share difficulty via the password field, e.g. `--password 'x;d=65536'`. Other Pearl dialects ignore it.
- `--diff <N>` (v2.0.8): convenience for `--password 'x;d=N'` — pin **AlphaPool** static difficulty to `N` (pool minimum **20000**; `--diff 0` or any non-numeric value is rejected). Recommended on fast cards so the share rate doesn't outrun submission, e.g. a 5090 → `--diff 131072`.

The miner auto-picks the best matrix shape for your card, prints a periodic hashrate line, mines until you stop it (Ctrl+C), and **auto-reconnects** through pool restarts / network blips / stalled links.

**Requirements**
- **NVIDIA GPU, Ampere or newer** (RTX 30 / 40 / 50, A100, H100). RTX 20-series (Turing, tensor-core) supported since v2.0.3; GTX 16xx (no tensor cores) and pre-Turing not supported.
- **≥ 8 GB VRAM.** 8 GB / 10 GB cards (e.g. 3060 Ti / 3070 / 3080 10G / 4060 Ti 8G / 5060 Ti 8G) **automatically use the low-VRAM mode** since v2.0.1 — no speed penalty; ≥ 12 GB cards are completely unchanged. If VRAM is genuinely insufficient, the miner shows a clear bilingual message and skips the card.
- **NVIDIA driver ≥ 570.26 (Linux, CUDA 12 build) / ≥ 580.88 (Windows, CUDA 13 build).** Nothing else to install — the CUDA runtime ships in the bundle.
- The pool connection transport (TLS / plaintext) follows your `--pool` scheme prefix (see the command line above).

> **Driver too old?** If the miner exits immediately with `cudaGetDeviceCount returned 0` or `pk_init failed`, your driver is below the minimum — **update the driver** (a driver-version issue, not a GPU problem). Check with `nvidia-smi`.

> **Antivirus false positive?** Some antivirus products (including Windows Defender) may falsely flag the miner — a common false positive for small mining binaries; add the miner folder to your exclusions if it gets quarantined.

</details>

---
Built from the Pearl Rust miner (private source repo). One binary, every supported GPU.
