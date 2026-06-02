# tw-pearl-miner

[English](README.en.md) | [简体中文](README.md) | **繁體中文**

為 **Pearl** 礦池（`pearl.tw-pool.com:50001`，已內建）預先編譯的 GPU 挖礦程式。
提供 Windows + Linux 執行檔，以及 HiveOS 自訂礦工套件。

單一胖二進位（fat binary）可在**任何 Ampere 或更新的 NVIDIA 顯示卡**上執行 —— RTX 30 / 40 / 50 系列、
A100、H100（原生 SASS 支援 sm_80/86/89/90/120a + PTX 後備）。不支援 Ampere 之前的顯示卡
（GTX 10xx / RTX 20xx）。

## v1.4.0 更新內容
- **啟動時顯示版本。** 啟動時挖礦程式會印出 `tw-pearl-miner v1.4.0`，讓你隨時知道自己執行的是哪個版本。
- **更可靠的份額提交。**

## v1.3.9.1 更新內容
- **修復多卡（8 卡/多 GPU）礦機卡死**（GPU 同步時 CPU 忙等導致負載飆升）。**多卡礦機使用者請升級到 v1.3.9.1。** 單卡/桌面 GPU 使用者不受影響（升級可選）。*（Windows 二進位與 v1.3.9 相同——此問題僅影響多 GPU 的 Linux/HiveOS 礦機。）*

## v1.3.9 更新內容
- RTX 5090 挖礦路徑最佳化（有效份額 **+2–4%**）。
- **H100 / H200 / 資料中心顯卡現可正確挖礦** —— 此前 100% 被拒絕；H100 現約 **625 TH/s**。
- HiveOS：**儀表板現在顯示每張顯卡的算力**（此前僅顯示總算力）。

## 下載

| 平台 | 下載 |
|----------|----------|
| Windows  | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-windows.zip) |
| Linux    | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-linux.zip) |
| HiveOS   | [自訂礦工套件](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-1.4.0.tar.gz) + [安裝指南](hiveos/) |

用 [`SHA256SUMS`](SHA256SUMS) 驗證：`sha256sum -c SHA256SUMS`。

> **老舊租用機器（驅動 570–580 / CUDA 12.8）？** 如果一般 Linux 版啟動即報 `cudaGetDeviceCount returned 0` / `pk_init failed`（驅動太舊、無法執行需要 ≥580.65 的 CUDA 13），請改用 CUDA-12.8 版——速度相同，驅動 ≥570.26 即可執行：[`tw-pearl-miner-1.4.0-cuda12.tar.gz`](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-1.4.0-cuda12.tar.gz)。

## 快速開始

### Windows
1. 下載並解壓縮 `tw-pearl-miner-windows.zip`。
2. 編輯 `start.bat`，把 `WALLET` 設成你的 `prl1...` 位址 —— 或直接執行它，依提示貼上位址。
3. 按兩下 `start.bat`。

> ⚠️ **請用指令或上面表格裡的連結下載，不要在 github.com 上打開檔案再「另存新檔」**（那樣存下來的是 HTML 網頁，根本解不開——這是「無法解壓縮」的頭號原因）。下面的 `wget`/`curl` 指令才會下載到真正的檔案。

一行安裝（全自動）：
```bash
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
```
或手動下載 + 解壓縮（兩種格式內容相同，二選一）：
```bash
# .tar.gz
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux

# ……或 .zip
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.0/tw-pearl-miner-linux.zip
unzip tw-pearl-miner-linux.zip && cd tw-pearl-miner-linux
```
然後設定錢包並執行：
```bash
nano start.sh          # 設定 WALLET=你的 prl1... 位址
bash start.sh          # 選用：bash start.sh <worker名稱>
```

### HiveOS
在 HiveOS 中「新增自訂礦工」（Add Custom Miner），使用 [`hiveos/README.md`](hiveos/README.md)
裡的安裝 URL，並在 flight sheet 中填入你的錢包位址。完整說明見該文件。

## 預期算力

下面是每張卡在挖礦程式**自動選擇**的形狀下的大致 Pearl 算力（預設頻率 / 功耗）：

**GeForce RTX 50（Blackwell）**

| 顯示卡 | Pearl 算力 |
|-----|----------------|
| RTX 5090 | ~325 TH/s |
| RTX 5080 | ~188 TH/s |
| RTX 5070 Ti | ~157 TH/s |
| RTX 5070 | ~111 TH/s |
| RTX 5060 Ti | ~76 TH/s |
| RTX 5060 | ~63 TH/s |

**GeForce RTX 40（Ada）**

| 顯示卡 | Pearl 算力 |
|-----|----------------|
| RTX 4090 | ~190 TH/s |
| RTX 4080 | ~160 TH/s *(估算)* |
| RTX 4070 Ti | ~133 TH/s |
| RTX 4070 | ~102 TH/s |
| RTX 4060 Ti | ~69 TH/s |

**資料中心卡**

| 顯示卡 | Pearl 算力 |
|-----|----------------|
| H100 SXM | ~625 TH/s |
| A100 SXM4（40 GB） | ~142 TH/s |

> 在 Pearl 礦池上以**預設頻率**測得；功耗牆 / 超頻調校可再提升幾個百分點，實際結果因主機與散熱而異。
> 資料中心卡的數值是 **SXM** 版本 —— **PCIe** 版本會略低一些。

## 使用

```
pearl-gpu-miner --wallet <prl1...位址> [--worker <名稱>] [--gpus 0,1]
```
- `--wallet`（必填）：你的收款位址。
- `--worker`（預設：機器名稱）：礦池上顯示的礦機名稱。
- `--gpus`（預設：全部）：以逗號分隔的裝置編號，例如 `0,1,2,3`。

挖礦程式會自動為你的顯示卡選擇最佳矩陣形狀，定期印出一行算力，持續挖礦直到你停止（Ctrl+C），
並在礦池重啟 / 網路抖動時自動重連。

### 系統需求
- **NVIDIA 顯示卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。不支援 Ampere 之前的顯示卡（GTX 10xx / RTX 20xx）。
- **NVIDIA 驅動程式 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** —— 即支援 CUDA 13 的驅動程式。*更新的版本一律沒問題；最省事的就是裝最新驅動程式。*
- 不需要安裝其他任何東西 —— CUDA 執行階段已打包在內。

> **驅動程式太舊？** 如果挖礦程式一啟動就退出，並回報 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，
> 表示你的驅動程式低於上面的最低需求 —— 請**更新驅動程式**（這是驅動程式版本問題，不是顯示卡問題）。用 `nvidia-smi`
> 查看，顯示的「CUDA Version」必須是 **13.0 或更高**。

### 連線 / TLS
礦池連線使用 **TLS** 加密。

---
基於 Pearl Rust 挖礦程式建置（私有原始碼倉庫）。一個二進位，支援所有受支援的顯示卡。
