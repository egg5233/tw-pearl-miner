# tw-pearl-miner

[English](README.md) | [简体中文](README.zh-CN.md) | **繁體中文**　·　[最新版本 ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)　·　[💬 Discord 社群](https://discord.gg/J6NHCrwmx2)

**開發者費用：1.5%**（挖礦程式啟動時亦會顯示）。

## 支援的礦池

- [PearlFortune](https://pearlfortune.org)
- [HeroMiners](https://pearl.herominers.com)
- [AlphaPool](https://alphapool.tech)
- [Kryptex](https://pool.kryptex.com/prl)
- [LuckyPool](https://pearl.luckypool.io/)

## 預期算力 (pool-effective)

每張卡在挖礦程式**自動選擇**形狀下的大致 Pearl 算力（**預設頻率**）。功耗牆 / 超頻可再加幾個百分點；**實際數值依礦池 / 難度而異**，也因主機與散熱不同。

| 50 | TH/s | 40 | TH/s | 30 | TH/s | DC | TH/s |
|---|---|---|---|---|---|---|---|
| 5090 | 360@600w | 4090 | 295.5@450w | 3090 | 108.6@347w | A100 | 206.1@398w |
| 5090 | 330@505w |  |  |  |  |  |  |
| 5080 | 211.1@339w | 4080 | 183@320w | 3080 Ti | 112.6@349w | H100 | 622.7@697w |
| 5070 Ti | 172.1@300w | 4070TS | 157.8@285w | 3080 | 98.5@319w | B200 | 1162@1000w |
| 5070 | 119.2 | 4070 Ti | 143.7 | 3070 Ti | 76.9 |  |  |
| 5060 Ti | 89.9 | 4070S | 123.1 | 3070 | 72.9 |  |  |
| 5060 | 71.4 | 4070 | 108.3 | 3060 Ti | 54.7 |  |  |
|  |  | 4060 Ti | 81.2 |  |  |  |  |
|  |  | 4060 | 55.2 |  |  |  |  |

未列出的型號同樣支援（Ampere 及更新，顯示記憶體 ≥ 8 GB），數值後續補充。資料中心卡的數值是 **SXM** 版本 —— **PCIe** 版本會略低一些。
**RTX 20 系（Turing）** 自 **v2.0.3** 起支援 —— 例如 RTX 2080 Ti ~59 TH/s。（GTX 16 系無 Tensor Core，不支援。）

| 系統 | NVIDIA 驅動 | 下載 |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-windows.zip) |
| **Linux**（桌面 / 伺服器） | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-linux.tar.gz) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-2.1.2.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-2.1.2.tar.gz) |
| **Linux** —— 舊驅動 | 570.26–580 | [tw-pearl-miner-2.1.2-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-2.1.2-cuda12.tar.gz) |
| **HiveOS** —— 舊驅動 | 570.26–580 | [tw-pearl-miner-2.1.2.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-2.1.2.c12.tar.gz) |

## 快速開始

**只想挖礦？填入你的錢包地址，複製對應你系統的那一行，執行即可：**

**Linux / HiveOS**（在解壓後的資料夾內）：
```
./pearl-gpu-miner --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

**Windows**（在解壓後的資料夾內）：
```
pearl-gpu-miner.exe --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

把 YOUR_WALLET 換成你的 prl1... 收款地址；.worker 只是你的礦機名。

### Windows
1. 下載並解壓縮 `tw-pearl-miner-windows.zip`。
2. 編輯 `start.bat`，把 `WALLET` 設成你的 `prl1...` 位址、`POOL` 設成你的礦池位址 —— 或直接執行它，依提示輸入。
3. 按兩下 `start.bat`。

```bash
# 一行安裝 —— 自動下載並解壓縮
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ……或手動：
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.2/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # 設定 WALLET=你的 prl1... 位址、POOL=你的礦池位址
bash start.sh          # 選用：bash start.sh <worker名稱>
```

### HiveOS
在 HiveOS 中「新增自訂礦工」（Add Custom Miner），使用 [`hiveos/README.zh-TW.md`](hiveos/README.zh-TW.md) 裡的安裝 URL；flight sheet 需填 **Pool URL（必填，可含協定前綴）** 與 **錢包位址**，Extra config 為 `--` 參數寫法（1.x 的 `CN2=1` / `POOL_TLS=0` 環境變數寫法已廢除，遷移說明見該文件）。完整說明見該文件。


<details>
<summary><b>全部選項與系統需求</b></summary>

**指令列**
```
pearl-gpu-miner --pool <礦池位址> --wallet <prl1...位址> [--worker <名稱>] [--gpus 0,1]
```
- `--pool`（必填）：礦池位址，支援以下寫法：
  - `host:port` —— **自動偵測連線方式**（自 v2.0.2 起適用於任意礦池：啟動時自動判斷 TLS 或明文，無需手填協定；例：`hk.pearl.herominers.com:1200`）。
  - `stratum+ssl://host:port` —— TLS 加密並驗證憑證。
  - `stratum+tcp://host:port` —— 明文連線。
  - `stratum+ssl-insecure://host:port` —— TLS 加密但不驗證憑證（中繼 / IP 直連用）。
- `--wallet`（必填）：你的收款位址。
- `--worker`（預設：機器名稱）：礦池上顯示的礦機名稱。
- `--gpus`（預設：全部）：以逗號分隔的裝置編號，例如 `0,1,2,3`。
- `--low-vram`（v2.0.2）：在所有顯示卡上強制低顯示記憶體模式（釋放約 8 GB 顯示記憶體、速度不變；8–10 GB 顯示卡本就自動啟用）。適合共享 GPU 的機器。
- `--no-tui`（v2.0.2）：使用經典單行輸出。預設在互動終端中自動啟用全螢幕介面（即時顯示各卡算力、溫度、份額與日誌）；重新導向 / 指令稿 / HiveOS 環境自動回退單行模式。
- `--password <字串>`（v2.0.8）：stratum 密碼。在 **AlphaPool**（`*.alphapool.tech`）上透過密碼欄位鎖定靜態份額難度，例如 `--password 'x;d=65536'`；其他 Pearl 方言會忽略此參數。
- `--diff <N>`（v2.0.8）：`--password 'x;d=N'` 的便捷寫法 —— 將 **AlphaPool** 靜態難度鎖定為 `N`（礦池最低 **20000**；`--diff 0` 或非數字會被拒絕）。建議高算力顯卡使用，避免份額提交頻率超過提交速度，例如 5090 → `--diff 131072`。
- `--pf`（v2.0.9）：將礦池標記為 **PearlFortune**。直連 PearlFortune 時會依主機名自動辨識（例如 `--pool jp.pearlfortune.org:8888`）；僅當透過本地轉發器連線（位址不是 pearlfortune 主機）時才需加上 `--pf`。

挖礦程式會自動為你的顯示卡選擇最佳矩陣形狀，定期印出一行算力，持續挖礦直到你停止（Ctrl+C），並在礦池重啟 / 網路抖動 / 連線卡死時**自動重連**。

**系統需求**
- **NVIDIA 顯示卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。RTX 20 系（Turing，含 Tensor Core）自 v2.0.3 起支援；GTX 16xx（無 Tensor Core）及更早顯示卡不支援。
- **顯示記憶體 ≥ 8 GB**。8 GB / 10 GB 顯示卡（如 3060 Ti / 3070 / 3080 10G / 4060 Ti 8G / 5060 Ti 8G）自 v2.0.1 起**自動啟用低顯示記憶體模式**，速度不打折；≥ 12 GB 顯示卡行為完全不變。顯示記憶體確實不足時會顯示清晰的中英文提示並跳過該卡。
- **NVIDIA 驅動程式 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** 對應 CUDA 13 版本；或 **≥ 570.26** 對應 CUDA 12 版本。不需要安裝其他東西 —— CUDA 執行階段已打包在內。
- 礦池連線方式（TLS / 明文）取決於你的 `--pool` 協定前綴（見上面指令列說明）。

> **驅動程式太舊？** 如果挖礦程式一啟動就退出並回報 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，表示驅動低於最低需求 —— 請**更新驅動程式**（這是驅動版本問題，不是顯示卡問題），或改用上面的 **CUDA 12** 版本。用 `nvidia-smi` 查看。

> **防毒軟體誤報？** 部分防毒軟體（含 Windows Defender）可能將挖礦程式誤報為威脅 —— 這是小體積挖礦程式的常見誤報；如被攔截請將挖礦程式目錄加入排除清單。

</details>

---
基於 Pearl Rust 挖礦程式建置（私有原始碼倉庫）。一個二進位，支援所有受支援的顯示卡。
