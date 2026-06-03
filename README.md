# tw-pearl-miner

[English](README.en.md) | **简体中文** | [繁體中文](README.zh-TW.md)　·　[最新版本 ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)

为 **Pearl** 矿池（`pearl.tw-pool.com:50001`，已内置）预编译的 GPU 矿工程序 —— 单个二进制可运行在**任何 Ampere 及更新的 NVIDIA 显卡**（RTX 30 / 40 / 50、A100、H100）上，支持 **Windows · Linux · HiveOS**。不支持 Ampere 之前的显卡（GTX 10xx / RTX 20xx）。

> **最新（v1.4.3）：** 用户名挖矿 —— 在矿池网站设置好钱包后，用简短用户名挖矿：`pearl-gpu-miner -u <用户名>`（`--wallet <prl1…>` 仍可用）。另外：Linux 程序现已自包含。[完整更新日志 ↗](https://github.com/egg5233/tw-pearl-miner/releases)

## 下载

**两个问题：**

1. **你用的是什么系统？** —— Windows、Linux（桌面/服务器）或 HiveOS 矿机。
2. **你的 NVIDIA 驱动有多新？** —— 运行 `nvidia-smi` 查看：**≥ 580.65** → 普通 **CUDA 13** 版本 · **570.26–580** → **CUDA 12** 版本（`-cuda12` / `.c12`） · **< 570.26** → 请先更新驱动。

| 你的系统 | NVIDIA 驱动 | 下载 |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-windows.zip) |
| **Linux**（桌面 / 服务器） | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-linux.zip) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-1.4.3.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-1.4.3.tar.gz) |
| **Linux** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-1.4.3-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-1.4.3-cuda12.tar.gz) |
| **HiveOS** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-1.4.3.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-1.4.3.c12.tar.gz) |

> **`.tar.gz` 与 `.zip`**（Linux）是**同一个版本**，只是压缩格式不同。**CUDA 12 版本**（`-cuda12`、`.c12`）**速度与功能完全一致** —— 只是内置的 CUDA 运行库不同，所以能在**较旧的驱动（≥ 570.26）**上启动；仅当普通版本启动时报 `cudaGetDeviceCount returned 0` / `pk_init failed` 时才用。可用 [`SHA256SUMS`](SHA256SUMS) 校验：`sha256sum -c SHA256SUMS`。

## 快速开始

### Windows
1. 下载并解压 `tw-pearl-miner-windows.zip`。
2. 编辑 `start.bat`，把 `WALLET` 设为你的 `prl1...` 地址 —— 或者直接运行它，按提示粘贴地址。
3. 双击 `start.bat`。

### Linux
> ⚠️ 请用表格里的链接或下面的 `wget`/`curl` 下载，**不要**在 github.com 上打开文件再「另存为」（那样存下来的是 HTML 网页，根本解不开——这是「无法解压」的头号原因）。

```bash
# 一行安装 —— 自动下载、解压、提示填钱包并运行
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ……或手动（.tar.gz 或 .zip，内容相同）：
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.4.3/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # 设置 WALLET=你的 prl1... 地址
bash start.sh          # 可选：bash start.sh <worker名称>
```

### HiveOS
在 HiveOS 中「添加自定义矿工」（Add Custom Miner），使用 [`hiveos/README.md`](hiveos/README.md) 里的安装 URL，并在飞行表中填入你的钱包地址。完整说明见该文档。

<details>
<summary><b>预期算力</b> —— RTX 30 / 40 / 50、A100、H100</summary>

每张卡在矿工**自动选择**形状下的大致 Pearl 算力（**默认频率**）。功耗墙 / 超频可再加几个百分点；实际结果因主机与散热而异。

| RTX 50（Blackwell） | TH/s | RTX 40（Ada） | TH/s | 数据中心 | TH/s |
|---|---|---|---|---|---|
| RTX 5090 | ~325 | RTX 4090 | ~250 | H100 SXM | ~625 |
| RTX 5080 | ~188 | RTX 4080 | ~160 *(估算)* | A100 SXM4 40 GB | ~142 |
| RTX 5070 Ti | ~157 | RTX 4070 Ti | ~133 | | |
| RTX 5070 | ~111 | RTX 4070 | ~102 | | |
| RTX 5060 Ti | ~76 | RTX 4060 Ti | ~69 | | |
| RTX 5060 | ~63 | | | | |

数据中心卡的数值是 **SXM** 版本 —— **PCIe** 版本会略低一些。

</details>

<details>
<summary><b>全部选项与系统要求</b></summary>

**命令行**
```
pearl-gpu-miner --wallet <prl1...地址> [--worker <名称>] [--gpus 0,1]
pearl-gpu-miner -u <用户名>            [--worker <名称>] [--gpus 0,1]
```
- `--wallet`（必填）：你的收款地址。
- `-u <用户名>`：用矿池用户名代替 `--wallet` 挖矿（请先在矿池网站设置好收款地址，矿池会把用户名解析为你的地址）。`--wallet` 与 `-u` 二选一。
- `--worker`（默认：机器名）：矿池上显示的矿机名。
- `--gpus`（默认：全部）：以逗号分隔的设备编号，例如 `0,1,2,3`。

矿工会自动为你的显卡选择最佳矩阵形状，定期打印一行算力，持续挖矿直到你停止（Ctrl+C），并在矿池重启 / 网络抖动 / 连接卡死时**自动重连**。

**系统要求**
- **NVIDIA 显卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。不支持 Ampere 之前的显卡（GTX 10xx / RTX 20xx）。
- **NVIDIA 驱动 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** 对应 CUDA 13 版本；或 **≥ 570.26** 对应 CUDA 12 版本。无需安装其他东西 —— CUDA 运行时已打包在内。
- 矿池连接使用 **TLS** 加密。

> **驱动太旧？** 如果矿工一启动就退出并报 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，说明驱动低于最低要求 —— 请**更新驱动**（这是驱动版本问题，不是显卡问题），或改用上面的 **CUDA 12** 版本。用 `nvidia-smi` 查看。

</details>

---
基于 Pearl Rust 矿工构建（私有源码仓库）。一个二进制，支持所有受支持的显卡。
