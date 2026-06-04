# tw-pearl-miner 在 HiveOS 上

[English](README.en.md) | **简体中文** | [繁體中文](README.zh-TW.md)

Pearl GPU 矿工的 HiveOS **自定义矿工（Custom Miner）** 安装包。支持任何 Ampere 及更新的
NVIDIA 显卡（RTX 30/40/50、A100、H100）。矿池已内置（`pearl.tw-pool.com:50001`）。

## 安装

1. 在 HiveOS 中打开你的矿机 → **飞行表（Flight Sheets）** → 新建一个飞行表（或先到 **钱包 Wallets**）。
2. **添加自定义矿工**（飞行表 → Miner → `+` → *Setup Miner Config* → **Custom**）：
   - **矿工名称（Miner name）：** `tw-pearl-miner`
   - **安装 URL（Installation URL）：**
     ```
     https://github.com/egg5233/tw-pearl-miner/releases/download/v1.7.0/tw-pearl-miner-1.7.0.tar.gz
     ```
     （如果你使用 GitHub Releases，也可以用
     `https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-1.7.0.tar.gz`）
   - **哈希算法（Hash algorithm）：** `pearl`（自由文本 —— 仅供参考）
3. 填写飞行表字段：
   | 字段 | 值 |
   |-------|-------|
   | **Wallet and worker template** | 你的 `prl1...` 收款地址 —— **或** 你的矿池用户名（请先在矿池网站设置好钱包地址，矿池会自动解析） |
   | **Pool URL** | *留空*（使用内置矿池）—— 或填 `host:port` 覆盖 |
   | **Pass** | `x` |
   | **Extra config arguments** | *（可选）* 额外的环境变量，每行一个 —— 例如 `CN2=1`（见下方 *直连矿池困难？*） |
4. 把飞行表应用到矿机。HiveOS 会下载安装包，安装到
   `/hive/miners/custom/tw-pearl-miner/`，然后开始挖矿。

矿机名会自动取自 rig；算力（TH/s）与接受/拒绝份额会显示在 HiveOS 面板上。

## 安装包内容
```
tw-pearl-miner/
  pearl-gpu-miner       矿工二进制（fat：sm_80/86/89/90/120a + PTX）
  libpearlkernel.so     CUDA 内核
  libcudart.so.13       CUDA 运行库
  h-manifest.conf       矿工元数据
  h-config.sh           从飞行表生成运行配置
  h-run.sh              启动矿工
  h-stats.sh            向 HiveOS 上报算力/份额
```

## 说明
- **显卡支持：** Ampere 或更新（需要 SM80 int8 张量核心）。不支持 Ampere 之前的显卡
  （GTX 10xx / RTX 20xx）。
- **驱动：** **≥ 580.65**（Linux）—— 支持 CUDA 13 的驱动。可在 HiveOS 网页端升级（矿机 → ⋮ →
  *Upgrade* / NVIDIA driver）或在 Hive Shell 里运行 `nvidia-driver-update`。如果矿工日志出现
  `cudaGetDeviceCount returned 0` / `pk_init failed`，说明驱动**太旧** —— `nvidia-smi` 必须显示
  “CUDA Version: 13.0” 或更高。
- **卡在 570–580 驱动（上不了 CUDA 13）？** 把安装 URL 换成 **CUDA-12.8** 版安装包 —— 速度相同，
  可在驱动 ≥ 570.26 上运行（内置 `libcudart.so.12`）：
  ```
  https://github.com/egg5233/tw-pearl-miner/releases/download/v1.7.0/tw-pearl-miner-1.7.0.c12.tar.gz
  ```
- **直连矿池困难？** 如果你的网络无法连接默认矿池地址，可在
  **Extra config arguments** 里设置 `CN2=1` 启用**中继线路**（备用、混淆的连接路径）——挖矿与
  收款完全不变，只是换一条到矿池的网络路径。
  - `CN2=1`：自动模式（推荐），自动挑选可用中继节点，连接失败时自动切换。
  - `PEARL_CN2=<编号>`：固定使用某个中继节点（编号 0–5），一般用于排查。
  - ⚠️ 在 HiveOS 上**必须**用 `key=value` 形式（`CN2=1` / `PEARL_CN2=2`）——单独写一行 `--cn2`
    **不行**（会被当成 shell 命令）。矿工的启动日志会显示当前使用的连接模式。
- **TLS：** 默认矿池连接使用 TLS 加密。
- **算力单位：** 矿工的指标是 TH/s；HiveOS 按比例显示（`total khs` 字段 = `TH/s × 1e9`）。
