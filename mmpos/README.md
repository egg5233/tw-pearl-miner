# tw-pearl-miner on MMPOS

A custom-miner package for the [MMPOS](https://app.mmpos.eu) mining OS (the peer of the HiveOS package).

## Download

| NVIDIA driver | Package |
|---|---|
| ≥ 580.65 (recent) | [tw-pearl-miner-2.3.2_mmpos.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-2.3.2_mmpos.tar.gz) |
| 570.26–580 (older) | [tw-pearl-miner-2.3.2_mmpos.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-2.3.2_mmpos.c12.tar.gz) |

If the miner exits immediately with `cudaGetDeviceCount returned 0` / `pk_init failed`, your driver is too old for this build — use the **older-driver** package above (or update the driver).

## Install (MMPOS custom miner)

1. In MMPOS, add a **Custom miner** and point its install URL at the `…_mmpos.tar.gz` above (miner name `tw-pearl-miner`).
2. Create a wallet/pool for it:
   - **Pool** = your Pearl pool `host:port` (e.g. `hk.pearl.herominers.com:1200`). TLS vs plaintext is auto-detected; you can also pin a scheme (`stratum+ssl://…` / `stratum+tcp://…`).
   - **Wallet** = your `prl1…` payout address. MMPOS passes `address.worker`; the launcher splits it into the miner's `--wallet` + `--worker` automatically.
3. **Extra config** flags pass straight through to the miner, e.g.:
   - `--rank 512` (rank; auto by card otherwise) · `--gpus 0,1` · `--shape 65536x65536`
   - `--intensity <1-4>` (default 1). Leave at **1** unless you know your pool's jobs are slow — `>1` can produce **stale (rejected)** shares on pools that push jobs often; hashrate is unchanged.

## What's in the package

`mmp-launch.sh` (maps MMPOS's generic flags → the miner's CLI, sets `LD_LIBRARY_PATH`), `mmp-stats.sh` (parses the miner log → the MMPOS hashrate/shares JSON), `mmp-external.conf`, plus the miner binary + `libpearlkernel.so` + `libcudart.so`.
