# tw-pearl-miner

Pre-built GPU miner for the **Pearl** pool (`pearl.tw-pool.com:50001`, built in).
Windows + Linux binaries, plus a HiveOS custom-miner package.

One fat binary runs on **any Ampere-or-newer NVIDIA GPU** — RTX 30 / 40 / 50 series, A100,
H100 (native SASS for sm_80/86/89/90/120a + a PTX fallback). Pre-Ampere (GTX 10xx / RTX 20xx)
is not supported.

## Downloads

| Platform | Download |
|----------|----------|
| Windows  | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/raw/main/windows/tw-pearl-miner-windows.zip) |
| Linux    | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/raw/main/linux/tw-pearl-miner-linux.tar.gz) |
| HiveOS   | [custom-miner package](https://github.com/egg5233/tw-pearl-miner/raw/main/hiveos/tw-pearl-miner.tar.gz) + [setup guide](hiveos/) |

Verify with [`SHA256SUMS`](SHA256SUMS): `sha256sum -c SHA256SUMS`.

## Quick start

### Windows
1. Download and extract `tw-pearl-miner-windows.zip`.
2. Edit `start.bat` and set your `WALLET` (your `prl1...` address) — or just run it and paste the address when asked.
3. Double-click `start.bat`.

### Linux
One-line install:
```bash
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
```
Or manually:
```bash
tar xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # set WALLET=your prl1... address
chmod +x start.sh
./start.sh             # optional: ./start.sh <worker-name>
```

### HiveOS
Add a Custom Miner with the installation URL from [`hiveos/README.md`](hiveos/README.md) and set your
wallet in the flight sheet. Full instructions there.

## Usage

```
pearl-gpu-miner --wallet <prl1...address> [--worker <name>] [--gpus 0,1]
```
- `--wallet` (required): your payout address.
- `--worker` (default: machine name): rig name shown on the pool.
- `--gpus` (default: all): comma-separated device ids, e.g. `0,1,2,3`.

The miner auto-tunes the best matrix shape for your card at startup, shows a periodic hashrate
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
