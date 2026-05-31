# tw-pearl-miner

[English](README.en.md) | **简体中文** | [繁體中文](README.zh-TW.md)

为 **Pearl** 矿池（`pearl.tw-pool.com:50001`，已内置）预编译的 GPU 矿工程序。
提供 Windows + Linux 二进制，以及 HiveOS 自定义矿工包。

单个胖二进制（fat binary）可运行在**任何 Ampere 及更新的 NVIDIA 显卡**上 —— RTX 30 / 40 / 50 系列、
A100、H100（原生 SASS 支持 sm_80/86/89/90/120a + PTX 兜底）。不支持 Ampere 之前的显卡
（GTX 10xx / RTX 20xx）。

## 下载

| 平台 | 下载 |
|----------|----------|
| Windows  | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/raw/main/windows/tw-pearl-miner-windows.zip) |
| Linux    | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/raw/main/linux/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/raw/main/linux/tw-pearl-miner-linux.zip) |
| HiveOS   | [自定义矿工包](https://github.com/egg5233/tw-pearl-miner/raw/main/hiveos/tw-pearl-miner-1.3.6.tar.gz) + [安装指南](hiveos/) |

用 [`SHA256SUMS`](SHA256SUMS) 校验：`sha256sum -c SHA256SUMS`。

## 快速开始

### Windows
1. 下载并解压 `tw-pearl-miner-windows.zip`。
2. 编辑 `start.bat`，把 `WALLET` 设为你的 `prl1...` 地址 —— 或者直接运行它，按提示粘贴地址。
3. 双击 `start.bat`。

> ⚠️ **请用命令或上面表格里的链接下载，不要在 github.com 上打开文件再「另存为」**（那样存下来的是 HTML 网页，根本解不开——这是「无法解压」的头号原因）。下面的 `wget`/`curl` 命令才会下到真正的文件。

一行安装（全自动）：
```bash
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
```
或手动下载 + 解压（两种格式内容相同，二选一）：
```bash
# .tar.gz
wget https://github.com/egg5233/tw-pearl-miner/raw/main/linux/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux

# ……或 .zip
wget https://github.com/egg5233/tw-pearl-miner/raw/main/linux/tw-pearl-miner-linux.zip
unzip tw-pearl-miner-linux.zip && cd tw-pearl-miner-linux
```
然后设置钱包并运行：
```bash
nano start.sh          # 设置 WALLET=你的 prl1... 地址
bash start.sh          # 可选：bash start.sh <worker名称>
```

### HiveOS
在 HiveOS 中「添加自定义矿工」（Add Custom Miner），使用 [`hiveos/README.md`](hiveos/README.md)
里的安装 URL，并在飞行表（flight sheet）中填入你的钱包地址。完整说明见该文档。

## 预期算力

下面是每张卡在矿工**自动选择**的形状下的大致 Pearl 算力（默认频率 / 功耗）：

**GeForce RTX 50（Blackwell）**

| 显卡 | Pearl 算力 |
|-----|----------------|
| RTX 5090 | ~325 TH/s |
| RTX 5080 | ~188 TH/s |
| RTX 5070 Ti | ~157 TH/s |
| RTX 5070 | ~111 TH/s |
| RTX 5060 Ti | ~76 TH/s |
| RTX 5060 | ~63 TH/s |

**GeForce RTX 40（Ada）**

| 显卡 | Pearl 算力 |
|-----|----------------|
| RTX 4090 | ~190 TH/s |
| RTX 4080 | ~160 TH/s *(估算)* |
| RTX 4070 Ti | ~133 TH/s |
| RTX 4070 | ~102 TH/s |
| RTX 4060 Ti | ~69 TH/s |

**数据中心卡**

| 显卡 | Pearl 算力 |
|-----|----------------|
| H100 SXM | ~650 TH/s |
| A100 SXM4（40 GB） | ~142 TH/s |

> 在 Pearl 矿池上以**默认频率**测得；功耗墙 / 超频调优可再提升几个百分点，实际结果因主机与散热而异。
> 数据中心卡的数值是 **SXM** 版本 —— **PCIe** 版本会略低一些。

## 使用

```
pearl-gpu-miner --wallet <prl1...地址> [--worker <名称>] [--gpus 0,1]
```
- `--wallet`（必填）：你的收款地址。
- `--worker`（默认：机器名）：矿池上显示的矿机名。
- `--gpus`（默认：全部）：以逗号分隔的设备编号，例如 `0,1,2,3`。

矿工会自动为你的显卡选择最佳矩阵形状，定期打印一行算力，持续挖矿直到你停止（Ctrl+C），
并在矿池重启 / 网络抖动时自动重连。

### 系统要求
- **NVIDIA 显卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。不支持 Ampere 之前的显卡（GTX 10xx / RTX 20xx）。
- **NVIDIA 驱动 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** —— 即支持 CUDA 13 的驱动。*更新的版本总是没问题；最省事的就是装最新驱动。*
- 无需安装其他任何东西 —— CUDA 运行时已经打包在内。

> **驱动太旧？** 如果矿工一启动就退出，并报 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，
> 说明你的驱动低于上面的最低要求 —— 请**更新驱动**（这是驱动版本问题，不是显卡问题）。用 `nvidia-smi`
> 查看，显示的 “CUDA Version” 必须是 **13.0 或更高**。

### 连接 / TLS
矿池连接使用 **TLS** 加密。

---
基于 Pearl Rust 矿工构建（私有源码仓库）。一个二进制，支持所有受支持的显卡。
