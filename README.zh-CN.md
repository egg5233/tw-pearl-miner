# tw-pearl-miner

[English](README.md) | **简体中文** | [繁體中文](README.zh-TW.md)　·　[最新版本 ↗](https://github.com/egg5233/tw-pearl-miner/releases/latest)　·　[💬 Discord 社区](https://discord.gg/J6NHCrwmx2)

**开发者费用：1.5%**（矿工启动时亦会显示）。


## 支持的矿池

- [PearlFortune](https://pearlfortune.org)
- [HeroMiners](https://pearl.herominers.com)
- [AlphaPool](https://alphapool.tech)
- [Kryptex](https://pool.kryptex.com/prl)
- [LuckyPool](https://pearl.luckypool.io/)

## 预期算力 (pool-effective*)

| 50 | TH/s | 40 | TH/s | 30 | TH/s | DC | TH/s |
|---|---|---|---|---|---|---|---|
| 5090 | 370@575w | 4090 | 295.5@450w | 3090 | 108.6@347w | A100 | 206.1@398w |
| 5090 | 330@505w | 4080 | 183@320w | 3080 Ti | 112.6@349w | H100 | 622.7@697w |
| 5080 | 211.1@339w | 4070TS | 157.8@285w | 3080 | 98.5@319w | B200 | 1162@1000w |
| 5070 Ti | 172.1@300w | 4070 Ti | 150.1@285w | 3070 Ti | 78.4@310w | PRO 6000 | 345@600w |
| 5070 | 119.6@250w | 4070S | 126.7@220w | 3070 | 70.4@215w |  |  |
| 5060 Ti | 89.5@180w | 4070 | 112.6@200w | 3060 Ti | 56.3@200w |  |  |
| 5060 | 73.9@145w | 4060 Ti | 78.2@165w |  |  |  |  |
|  |  | 4060 | 54.3@115w |  |  |  |  |

未列出的型号同样支持（Ampere 及更新，显存 ≥ 8 GB），
**RTX 20 系（Turing）** 自 **v2.0.3** 起支持 —— 例如 RTX 2080 Ti ~59 TH/s。（GTX 16 系无 Tensor Core，不支持。）

| 系统 | NVIDIA 驱动 | 下载 |
|---|---|---|
| **Windows** | ≥ 580.88 | [tw-pearl-miner-windows.zip](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-windows.zip) |
| **Linux**（桌面 / 服务器） | ≥ 580.65 | [tw-pearl-miner-linux.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-linux.tar.gz) |
| **HiveOS** | ≥ 580.65 | [tw-pearl-miner-2.1.5.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-2.1.5.tar.gz) |
| **Linux** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-2.1.5-cuda12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-2.1.5-cuda12.tar.gz) |
| **HiveOS** —— 旧驱动 | 570.26–580 | [tw-pearl-miner-2.1.5.c12.tar.gz](https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-2.1.5.c12.tar.gz) |

## 快速开始

**Linux / HiveOS**（在解压后的文件夹内）：
```
./pearl-gpu-miner --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

**Windows**（在解压后的文件夹内）：
```
pearl-gpu-miner.exe --pool us.pearl.herominers.com:1200 --wallet YOUR_WALLET.worker
```

把 YOUR_WALLET 换成你的 prl1... 收款地址；.worker = 矿机名。

### Windows
1. 下载并解压 `tw-pearl-miner-windows.zip`。
2. 编辑 `start.bat`，把 `WALLET` 设为你的 `prl1...` 地址、`POOL` 设为你的矿池地址 —— 或者直接运行它，按提示输入。
3. 双击 `start.bat`。

```bash
# 一行安装 —— 自动下载并解压
curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash

# ……或手动：
wget https://github.com/egg5233/tw-pearl-miner/releases/download/v2.1.5/tw-pearl-miner-linux.tar.gz
tar -xzf tw-pearl-miner-linux.tar.gz && cd tw-pearl-miner-linux
nano start.sh          # 设置 WALLET=你的 prl1... 地址、POOL=你的矿池地址
bash start.sh          # 可选：bash start.sh <worker名称>
```

### HiveOS
在 HiveOS 中「添加自定义矿工」（Add Custom Miner），使用 [`hiveos/README.zh-CN.md`](hiveos/README.zh-CN.md) 里的安装 URL；飞行表需填 **Pool URL（必填，可含协议前缀）** 与 **钱包地址**，Extra config 为 `--` 参数写法（1.x 的 `CN2=1` / `POOL_TLS=0` 环境变量写法已废除，迁移说明见该文档）。完整说明见该文档。


<details>
<summary><b>全部选项与系统要求</b></summary>

**命令行**
```
pearl-gpu-miner --pool <矿池地址> --wallet <prl1...地址> [--worker <名称>] [--gpus 0,1]
```
- `--pool`（必填）：矿池地址，支持以下写法：
  - `host:port` —— **自动探测连接方式**（自 v2.0.2 起适用于任意矿池：启动时自动判断 TLS 或明文，无需手填协议；例：`hk.pearl.herominers.com:1200`）。
  - `stratum+ssl://host:port` —— TLS 加密并验证证书。
  - `stratum+tcp://host:port` —— 明文连接。
  - `stratum+ssl-insecure://host:port` —— TLS 加密但不验证证书（中继 / IP 直连用）。
- `--wallet`（必填）：你的收款地址。
- `--worker`（默认：机器名）：矿池上显示的矿机名。
- `--gpus`（默认：全部）：以逗号分隔的设备编号，例如 `0,1,2,3`。
- `--low-vram`（v2.0.2）：在所有显卡上强制低显存模式（释放约 8 GB 显存、速度不变；8–10 GB 显卡本就自动启用）。适合共享 GPU 的机器。
- `--no-tui`（v2.0.2）：使用经典单行输出。默认在交互终端中自动启用全屏界面（实时显示各卡算力、温度、份额与日志）；重定向 / 脚本 / HiveOS 环境自动回退单行模式。
- `--password <字符串>`（v2.0.8）：stratum 密码。在 **AlphaPool**（`*.alphapool.tech`）上通过密码字段锁定静态份额难度，例如 `--password 'x;d=65536'`；其他 Pearl 方言会忽略此参数。
- `--diff <N>`（v2.0.8）：`--password 'x;d=N'` 的便捷写法 —— 将 **AlphaPool** 静态难度锁定为 `N`（矿池最低 **20000**；`--diff 0` 或非数字会被拒绝）。建议高算力显卡使用，避免份额提交频率超过提交速度，例如 5090 → `--diff 131072`。
- `--pf`（v2.0.9）：将矿池标记为 **PearlFortune**。直连 PearlFortune 时会依主机名自动识别（例如 `--pool jp.pearlfortune.org:8888`）；仅当通过本地转发器连接（地址不是 pearlfortune 主机）时才需加上 `--pf`。

矿工会自动为你的显卡选择最佳矩阵形状，定期打印一行算力，持续挖矿直到你停止（Ctrl+C），并在矿池重启 / 网络抖动 / 连接卡死时**自动重连**。

**系统要求**
- **NVIDIA 显卡，Ampere 或更新**（RTX 30 / 40 / 50、A100、H100）。RTX 20 系（Turing，含 Tensor Core）自 v2.0.3 起支持；GTX 16xx（无 Tensor Core）及更早显卡不支持。
- **显存 ≥ 8 GB**。8 GB / 10 GB 显卡（如 3060 Ti / 3070 / 3080 10G / 4060 Ti 8G / 5060 Ti 8G）自 v2.0.1 起**自动启用低显存模式**，速度不打折；≥ 12 GB 显卡行为完全不变。显存确实不足时会显示清晰的中英文提示并跳过该卡。
- **NVIDIA 驱动 ≥ 580.65（Linux）/ ≥ 580.88（Windows）** 对应 CUDA 13 版本；或 **≥ 570.26** 对应 CUDA 12 版本。无需安装其他东西 —— CUDA 运行时已打包在内。
- 矿池连接方式（TLS / 明文）取决于你的 `--pool` 协议前缀（见上面命令行说明）。

> **驱动太旧？** 如果矿工一启动就退出并报 `cudaGetDeviceCount returned 0` 或 `pk_init failed`，说明驱动低于最低要求 —— 请**更新驱动**（这是驱动版本问题，不是显卡问题），或改用上面的 **CUDA 12** 版本。用 `nvidia-smi` 查看。

> **杀毒软件误报？** 部分杀毒软件（含 Windows Defender）可能将矿工误报为威胁 —— 这是小体积挖矿程序的常见误报；如被拦截请将矿工目录加入排除清单。

</details>

---
基于 Pearl Rust 矿工构建（私有源码仓库）。一个二进制，支持所有受支持的显卡。
