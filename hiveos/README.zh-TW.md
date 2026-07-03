# tw-pearl-miner 在 HiveOS 上

[English](README.md) | [简体中文](README.zh-CN.md) | **繁體中文**

Pearl GPU 礦工的 HiveOS **自訂礦工（Custom Miner）** 安裝包。支援任何 Ampere 及更新的
NVIDIA 顯示卡（RTX 30/40/50、A100、H100）。

> **2.0.0 變更：** **不再內建礦池** —— 你需要在 **Pool URL** 欄位填寫自己的礦池（必填）；
> **Extra config arguments** 現在是礦工的 **命令列參數**（如 `--gpus 0,1`），不再是環境變數。
> 詳見下方 *從 1.x 升級*。

## 快速開始 —— 匯入飛行表（JSON）

不想手動設定？先新增一個 **PRL 錢包**（Wallets → 填入你的 `prl1...` 位址），再把下面的飛行表 JSON
匯入 HiveOS（**飛行表 Flight Sheets** → 匯入 / 貼上）。它已經配好了自訂礦工、安裝 URL、演算法與礦池 ——
你只需確認錢包，並視需要修改礦池即可。

```json
{
    "isFavorite": false,
    "items": [
        {
            "coin": "PRL",
            "dpool_ssl": false,
            "miner": "custom",
            "miner_alt": "tw-pearl-miner",
            "miner_config": {
                "algo": "pearlhash",
                "install_url": "https://github.com/egg5233/tw-pearl-miner/releases/download/v2.3.0/tw-pearl-miner-2.3.0.tar.gz",
                "miner": "tw-pearl-miner",
                "pass": "x",
                "template": "%WAL%.%WORKER_NAME%",
                "url": "hk.pearl.herominers.com:1200"
            },
            "pool_geo": [],
            "pool_ssl": false,
            "wal_id": 0
        }
    ]
}
```

- **`wal_id`** 指向你的 HiveOS 錢包（`0` = 你的第一個 PRL 錢包）；`%WAL%` 展開為該收款位址，
  `%WORKER_NAME%` 展開為礦機名。
- **`url`** 是礦池 —— 範例用的是 herominers 香港（`hk.pearl.herominers.com:1200`）。請改成你自己的礦池；
  若要用 TLS 或其它傳輸方式，依下方 *Pool URL* 說明加上 scheme。
- **`install_url`** 鎖定在 **v2.3.0** —— 有新版本時改成最新的 release 標籤。

想手動設定？依下面的步驟操作即可。

## 安裝

1. 在 HiveOS 中開啟你的礦機 → **飛行表（Flight Sheets）** → 新建一個飛行表（或先到 **錢包 Wallets**）。
2. **新增自訂礦工**（飛行表 → Miner → `+` → *Setup Miner Config* → **Custom**）：
   - **礦工名稱（Miner name）：** `tw-pearl-miner`
   - **安裝 URL（Installation URL）：**
     ```
     https://github.com/egg5233/tw-pearl-miner/releases/download/v2.3.0/tw-pearl-miner-2.3.0.tar.gz
     ```
     （也可用 `https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-2.3.0.tar.gz`）
   - **雜湊演算法（Hash algorithm）：** `pearl`（自由文字 —— 僅供參考）
3. 填寫飛行表欄位：
   | 欄位 | 值 |
   |-------|-------|
   | **Wallet and worker template** | 你的 `prl1...` 收款地址（或 `prl1....%WORKER_NAME%`；帶 `.worker` 後綴時該後綴作為礦機名） |
   | **Pool URL** | **必填** —— 你的礦池 `host:port`，或帶傳輸協定前綴（見下方） |
   | **Pass** | `x` |
   | **Extra config arguments** | *（可選）* 額外的礦工 **命令列參數**，例如 `--gpus 0,1`（見下方 *額外參數*）。**不是**環境變數。 |
4. 把飛行表套用到礦機。HiveOS 會下載安裝包到 `/hive/miners/custom/tw-pearl-miner/` 並開始挖礦。

![HiveOS 飛行表設定參考](hive_setting.png)

*HiveOS 飛行表設定參考 —— Custom configuration 範例：礦工名、安裝 URL、錢包模板、
**Pool URL**（例如 `stratum+ssl://hk.pearl.herominers.com:1200`）、Pass=`x`、
Extra config arguments 為命令列參數（例如 `--gpus 0,1`）。*

礦機名會自動取自 rig；算力（TH/s）與接受/拒絕份額會顯示在 HiveOS 面板上。

## Pool URL（必填 —— 協定前綴決定連線方式）

Pool URL 會**原樣**傳給礦工，URL 的協定前綴決定如何連線：

| Pool URL | 連線方式 |
|----------|----------|
| `host:port`（裸地址） | 內建**預設**礦池（herominers / kryptex / luckypool） |
| `stratum+ssl://host:port` | TLS（驗證憑證） |
| `stratum+tcp://host:port` | 明文 TCP |
| `stratum+ssl-insecure://host:port` | TLS 但不驗證憑證（例如中繼 / 自簽前端，如 `stratum+ssl-insecure://<ip>:1200`） |

非預設礦池需要帶明確的協定前綴。例如：`stratum+ssl://hk.pearl.herominers.com:1200`。

## 額外參數 = 命令列參數

**Extra config arguments** 裡填的內容會原樣附加到礦工命令列（SRBMiner 風格），多個參數用空格或換行
分隔。例如：
- `--gpus 0,1` —— 只在 0 號和 1 號顯示卡上挖礦
- `--no-tui` —— 關閉全螢幕 TUI（HiveOS 本就無頭執行，寫日誌時會自動關閉，一般無需手動設定）

## 從 1.x 升級

- **Pool URL 現在必填。** 1.x 使用內建礦池、此欄位留空。請填寫你的礦池 `host:port`（非預設礦池要帶
  協定前綴）。若留空，礦工不會啟動，日誌會提示你填寫。
- **Extra config 現在是命令列參數，不是環境變數。** 舊的 `POOL_TLS=0`、`CN2=1`、`PEARL_CN2=N`、
  `POOL_HOST=`、`NO_CPU=` 這類寫法已**移除**，填入後會在日誌裡被拒絕並給出遷移提示。傳輸方式改用
  Pool URL 的協定前綴（例如用 `stratum+tcp://` 代替 `POOL_TLS=0`），其它需求請用真正的 `--參數`。

## 安裝包內容
```
tw-pearl-miner/
  pearl-gpu-miner       礦工二進位（fat：sm_80/86/89/90/120a + PTX）
  libpearlkernel.so     CUDA 核心
  libcudart.so.13       CUDA 執行庫
  h-manifest.conf       礦工中繼資料（CUSTOM_VERSION=2.0.0）
  h-config.sh           從飛行表產生執行參數
  h-run.sh              啟動礦工
  h-stats.sh            向 HiveOS 回報算力/份額
```

## 說明
- **顯示卡支援：** Ampere 或更新（需要 SM80 int8 張量核心）。不支援 Ampere 之前的顯示卡（GTX 10xx / RTX 20xx）。
- **驅動：** **≥ 580.65**（Linux）—— 支援 CUDA 13 的驅動。可在 HiveOS 網頁端升級（礦機 → ⋮ →
  *Upgrade* / NVIDIA driver）或在 Hive Shell 裡執行 `nvidia-driver-update`。如果日誌出現
  `cudaGetDeviceCount returned 0` / `pk_init failed`，代表驅動**太舊** —— `nvidia-smi` 必須顯示
  「CUDA Version: 13.0」或更高。
- **卡在 570–580 驅動（上不了 CUDA 13）？** 改用 **CUDA-12.8** 版安裝包 —— 速度相同，可在驅動
  ≥ 570.26 上執行（內建 `libcudart.so.12`）：
  ```
  https://github.com/egg5233/tw-pearl-miner/releases/download/v2.3.0/tw-pearl-miner-2.3.0.c12.tar.gz
  ```
- **算力單位：** 礦工的指標是 TH/s；HiveOS 按比例顯示（`total khs` 欄位 = `TH/s × 1e9`）。
