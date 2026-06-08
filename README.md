# tw-pearl-miner

[English](README.en.md) | **简体中文** | [繁體中文](README.zh-TW.md)　·　[最新版本 ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)


| 系统 | NVIDIA 驱动 | 下载 |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-windows.zip) |
| **Linux**（桌面 / 服务器） | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-linux.tar.gz) · [.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-linux.zip) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-1.9.1.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-1.9.1.tar.gz) |
| **Linux** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-1.9.1-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-1.9.1-cuda12.tar.gz) |
| **HiveOS** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-1.9.1.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-1.9.1.c12.tar.gz) |

## 快速开始

### Windows
1. 下载并解压 `tw-pearl-miner-windows.zip`。
2. 编辑 `start.bat`，把 `WALLET` 设为你的 `prl1...` 地址 —— 或者直接运行它，按提示粘贴地址。
3. 双击 `start.bat`。

```bash
# 一行安装 —— 自动下载、解压、提示填钱包并运行
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ……或手动（.tar.gz 或 .zip，内容相同）：
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v1.9.1/tw-pearl-miner-linux.tar.gz
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
| RTX 5080 | ~188 | RTX 4080 | ~160 *(估算)* | A100 SXM4 40 GB | ~170 |
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
pearl-gpu-miner -u <用户名>[.<矿机名>]  [--gpus 0,1]
```
- `--wallet`（必填）：你的收款地址。
- `-u <用户名>`：用矿池用户名代替 `--wallet` 挖矿（请先在矿池网站设置好收款地址，矿池会把用户名解析为你的地址）。`--wallet` 与 `-u` 二选一。可在用户名后追加矿机名 `-u <用户名>.<矿机名>`（例如 `-u egg5233.my_rig`）—— 等同于 `-u <用户名> --worker <矿机名>`。
- `--worker`（默认：机器名）：矿池上显示的矿机名。
- `--gpus`（默认：全部）：以逗号分隔的设备编号，例如 `0,1,2,3`。
- `--cn2`（可选，**中继线路**）：当直连矿池（`pearl.tw-pool.com`）不稳定、延迟过高或无法连接时启用 —— 矿工会改为通过备用中继节点连接矿池（挖矿与收款完全不变，只是换一条到矿池的网络路径）。默认走直连，只有连接困难的矿工才需要它。
  - `--cn2` 或 `--cn2 auto`：自动模式（推荐），自动挑选可用节点，连接失败时自动切换。
  - `--cn2 N`：固定使用第 N 个节点（N = 0–5）。
  - 环境变量（HiveOS / 批量部署）：`CN2=1` = 自动；`PEARL_CN2=<编号>` = 固定某个节点。

矿工会自动为你的显卡选择最佳矩阵形状，定期打印一行算力，持续挖矿直到你停止（Ctrl+C），并在矿池重启 / 网络抖动 / 连接卡死时**自动重连**。

**系统要求**
- **NVIDIA 显卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。不支持 Ampere 之前的显卡（GTX 10xx / RTX 20xx）。
- **NVIDIA 驱动 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** 对应 CUDA 13 版本；或 **≥ 570.26** 对应 CUDA 12 版本。无需安装其他东西 —— CUDA 运行时已打包在内。
- 矿池连接使用 **TLS** 加密。

> **驱动太旧？** 如果矿工一启动就退出并报 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，说明驱动低于最低要求 —— 请**更新驱动**（这是驱动版本问题，不是显卡问题），或改用上面的 **CUDA 12** 版本。用 `nvidia-smi` 查看。

</details>

---
基于 Pearl Rust 矿工构建（私有源码仓库）。一个二进制，支持所有受支持的显卡。
