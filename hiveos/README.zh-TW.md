# tw-pearl-miner 在 HiveOS 上

[English](README.en.md) | [简体中文](README.md) | **繁體中文**

Pearl GPU 挖礦程式的 HiveOS **自訂礦工（Custom Miner）** 安裝包。支援任何 Ampere 或更新的
NVIDIA 顯示卡（RTX 30/40/50、A100、H100）。礦池已內建（`pearl.tw-pool.com:50001`）。

## 安裝

1. 在 HiveOS 中打開你的礦機 → **飛行表（Flight Sheets）** → 新建一個飛行表（或先到 **錢包 Wallets**）。
2. **新增自訂礦工**（飛行表 → Miner → `+` → *Setup Miner Config* → **Custom**）：
   - **礦工名稱（Miner name）：** `tw-pearl-miner`
   - **安裝 URL（Installation URL）：**
     ```
     https://github.com/egg5233/tw-pearl-miner/releases/download/v1.7.0/tw-pearl-miner-1.7.0.tar.gz
     ```
     （如果你使用 GitHub Releases，也可以用
     `https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-1.7.0.tar.gz`）
   - **雜湊演算法（Hash algorithm）：** `pearl`（自由文字 —— 僅供參考）
3. 填寫飛行表欄位：
   | 欄位 | 值 |
   |-------|-------|
   | **Wallet and worker template** | 你的 `prl1...` 收款位址 —— **或** 你的礦池使用者名稱（請先在礦池網站設定好錢包位址，礦池會自動解析） |
   | **Pool URL** | *留空*（使用內建礦池）—— 或填 `host:port` 覆寫 |
   | **Pass** | `x` |
   | **Extra config arguments** | *（可選）* 額外的環境變數，每行一個 —— 例如 `CN2=1`（見下方 *直連礦池困難？*） |
4. 把飛行表套用到礦機。HiveOS 會下載安裝包，安裝到
   `/hive/miners/custom/tw-pearl-miner/`，然後開始挖礦。

礦機名稱會自動取自 rig；算力（TH/s）與接受/拒絕份額會顯示在 HiveOS 儀表板上。

## 安裝包內容
```
tw-pearl-miner/
  pearl-gpu-miner       挖礦二進位（fat：sm_80/86/89/90/120a + PTX）
  libpearlkernel.so     CUDA 核心
  libcudart.so.13       CUDA 執行庫
  h-manifest.conf       礦工中繼資料
  h-config.sh           從飛行表產生執行設定
  h-run.sh              啟動礦工
  h-stats.sh            向 HiveOS 回報算力/份額
```

## 說明
- **顯示卡支援：** Ampere 或更新（需要 SM80 int8 張量核心）。不支援 Ampere 之前的顯示卡
  （GTX 10xx / RTX 20xx）。
- **驅動：** **≥ 580.65**（Linux）—— 支援 CUDA 13 的驅動。可在 HiveOS 網頁端升級（礦機 → ⋮ →
  *Upgrade* / NVIDIA driver）或在 Hive Shell 裡執行 `nvidia-driver-update`。如果礦工日誌出現
  `cudaGetDeviceCount returned 0` / `pk_init failed`，表示驅動**太舊** —— `nvidia-smi` 必須顯示
  「CUDA Version: 13.0」或更高。
- **卡在 570–580 驅動（上不了 CUDA 13）？** 把安裝 URL 換成 **CUDA-12.8** 版安裝包 —— 速度相同，
  可在驅動 ≥ 570.26 上執行（內建 `libcudart.so.12`）：
  ```
  https://github.com/egg5233/tw-pearl-miner/releases/download/v1.7.0/tw-pearl-miner-1.7.0.c12.tar.gz
  ```
- **直連礦池困難？** 如果你的網路無法連線預設礦池位址，可在
  **Extra config arguments** 裡設定 `CN2=1` 啟用**中繼線路**（備用、混淆的連線路徑）——挖礦與
  收款完全不變，只是換一條到礦池的網路路徑。
  - `CN2=1`：自動模式（推薦），自動挑選可用中繼節點，連線失敗時自動切換。
  - `PEARL_CN2=<編號>`：固定使用某個中繼節點（編號 0–5），一般用於排查。
  - ⚠️ 在 HiveOS 上**必須**用 `key=value` 形式（`CN2=1` / `PEARL_CN2=2`）——單獨寫一行 `--cn2`
    **不行**（會被當成 shell 指令）。礦工的啟動日誌會顯示目前使用的連線模式。
- **TLS：** 預設礦池連線使用 TLS 加密。
- **算力單位：** 礦工的指標是 TH/s；HiveOS 按比例顯示（`total khs` 欄位 = `TH/s × 1e9`）。
