# tw-pearl-miner

[English](README.en.md) | [简体中文](README.md) | **繁體中文**　·　[最新版本 ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)

為 **Pearl** 礦池（`pearl.tw-pool.com:50001`，已內建）預先編譯的 GPU 挖礦程式 —— 單一二進位可執行於**任何 Ampere 或更新的 NVIDIA 顯示卡**（RTX 30 / 40 / 50、A100、H100），支援 **Windows · Linux · HiveOS**。不支援 Ampere 之前的顯示卡（GTX 10xx / RTX 20xx）。

> **最新（v1.6.0）：** 更平滑的儀表板算力 —— 礦工現在會向礦池回報算力，讓儀表板上的算力讀數更穩定。僅用於顯示（不影響挖礦、份額或收益）；可用 `POOL_HASHRATE_REPORT_SECS` 調整或關閉。[完整更新日誌 ↗](https://github.com/egg5233/tw-pearl-miner/releases)

## 下載

**兩個問題：**

1. **你用的是什麼系統？** —— Windows、Linux（桌面/伺服器）或 HiveOS 礦機。
2. **你的 NVIDIA 驅動有多新？** —— 執行 `nvidia-smi` 查看：**≥ 580.65** → 一般 **CUDA 13** 版本 · **570.26–580** → **CUDA 12** 版本（`-cuda12` / `.c12`） · **< 570.26** → 請先更新驅動。

| 你的系統 | NVIDIA 驅動 | 下載 |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-windows.zip) |
| **Linux**（桌面 / 伺服器） | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-linux.zip) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-1.6.0.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-1.6.0.tar.gz) |
| **Linux** —— 舊驅動 | 570.26–580 | [tw-pearl-miner-1.6.0-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-1.6.0-cuda12.tar.gz) |
| **HiveOS** —— 舊驅動 | 570.26–580 | [tw-pearl-miner-1.6.0.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-1.6.0.c12.tar.gz) |

> **`.tar.gz` 與 `.zip`**（Linux）是**同一個版本**，只是壓縮格式不同。**CUDA 12 版本**（`-cuda12`、`.c12`）**速度與功能完全一致** —— 只是內建的 CUDA 執行庫不同，所以能在**較舊的驅動（≥ 570.26）**上啟動；僅當一般版本啟動時出現 `cudaGetDeviceCount returned 0` / `pk_init failed` 時才用。可用 [`SHA256SUMS`](SHA256SUMS) 校驗：`sha256sum -c SHA256SUMS`。

## 快速開始

### Windows
1. 下載並解壓縮 `tw-pearl-miner-windows.zip`。
2. 編輯 `start.bat`，把 `WALLET` 設成你的 `prl1...` 位址 —— 或直接執行它，依提示貼上位址。
3. 按兩下 `start.bat`。

### Linux
> ⚠️ 請用表格裡的連結或下面的 `wget`/`curl` 下載，**不要**在 github.com 上打開檔案再「另存新檔」（那樣存下來的是 HTML 網頁，根本解不開——這是「無法解壓縮」的頭號原因）。

```bash
# 一行安裝 —— 自動下載、解壓縮、提示填錢包並執行
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ……或手動（.tar.gz 或 .zip，內容相同）：
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.6.0/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # 設定 WALLET=你的 prl1... 位址
bash start.sh          # 選用：bash start.sh <worker名稱>
```

### HiveOS
在 HiveOS 中「新增自訂礦工」（Add Custom Miner），使用 [`hiveos/README.md`](hiveos/README.md) 裡的安裝 URL，並在 flight sheet 中填入你的錢包位址。完整說明見該文件。

<details>
<summary><b>預期算力</b> —— RTX 30 / 40 / 50、A100、H100</summary>

每張卡在挖礦程式**自動選擇**形狀下的大致 Pearl 算力（**預設頻率**）。功耗牆 / 超頻可再加幾個百分點；實際結果因主機與散熱而異。

| RTX 50（Blackwell） | TH/s | RTX 40（Ada） | TH/s | 資料中心 | TH/s |
|---|---|---|---|---|---|
| RTX 5090 | ~325 | RTX 4090 | ~250 | H100 SXM | ~625 |
| RTX 5080 | ~188 | RTX 4080 | ~160 *(估算)* | A100 SXM4 40 GB | ~142 |
| RTX 5070 Ti | ~157 | RTX 4070 Ti | ~133 | | |
| RTX 5070 | ~111 | RTX 4070 | ~102 | | |
| RTX 5060 Ti | ~76 | RTX 4060 Ti | ~69 | | |
| RTX 5060 | ~63 | | | | |

資料中心卡的數值是 **SXM** 版本 —— **PCIe** 版本會略低一些。

</details>

<details>
<summary><b>全部選項與系統需求</b></summary>

**指令列**
```
pearl-gpu-miner --wallet <prl1...位址> [--worker <名稱>] [--gpus 0,1]
pearl-gpu-miner -u <使用者名稱>[.<礦機名稱>]  [--gpus 0,1]
```
- `--wallet`（必填）：你的收款位址。
- `-u <使用者名稱>`：用礦池使用者名稱代替 `--wallet` 挖礦（請先在礦池網站設定好收款位址，礦池會把使用者名稱解析為你的位址）。`--wallet` 與 `-u` 二選一。可在使用者名稱後附加礦機名稱 `-u <使用者名稱>.<礦機名稱>`（例如 `-u egg5233.my_rig`）—— 等同於 `-u <使用者名稱> --worker <礦機名稱>`。
- `--worker`（預設：機器名稱）：礦池上顯示的礦機名稱。
- `--gpus`（預設：全部）：以逗號分隔的裝置編號，例如 `0,1,2,3`。

挖礦程式會自動為你的顯示卡選擇最佳矩陣形狀，定期印出一行算力，持續挖礦直到你停止（Ctrl+C），並在礦池重啟 / 網路抖動 / 連線卡死時**自動重連**。

**系統需求**
- **NVIDIA 顯示卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。不支援 Ampere 之前的顯示卡（GTX 10xx / RTX 20xx）。
- **NVIDIA 驅動程式 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** 對應 CUDA 13 版本；或 **≥ 570.26** 對應 CUDA 12 版本。不需要安裝其他東西 —— CUDA 執行階段已打包在內。
- 礦池連線使用 **TLS** 加密。

> **驅動程式太舊？** 如果挖礦程式一啟動就退出並回報 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，表示驅動低於最低需求 —— 請**更新驅動程式**（這是驅動版本問題，不是顯示卡問題），或改用上面的 **CUDA 12** 版本。用 `nvidia-smi` 查看。

</details>

---
基於 Pearl Rust 挖礦程式建置（私有原始碼倉庫）。一個二進位，支援所有受支援的顯示卡。
