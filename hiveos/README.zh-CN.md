# tw-pearl-miner 在 HiveOS 上

[English](README.md) | **简体中文** | [繁體中文](README.zh-TW.md)

Pearl GPU 矿工的 HiveOS **自定义矿工（Custom Miner）** 安装包。支持任何 Ampere 及更新的
NVIDIA 显卡（RTX 30/40/50、A100、H100）。

> **2.0.0 变更：** **不再内置矿池** —— 你需要在 **Pool URL** 字段填写自己的矿池（必填）；
> **Extra config arguments** 现在是矿工的 **命令行参数**（如 `--gpus 0,1`），不再是环境变量。
> 详见下方 *从 1.x 升级*。

## 安装

1. 在 HiveOS 中打开你的矿机 → **飞行表（Flight Sheets）** → 新建一个飞行表（或先到 **钱包 Wallets**）。
2. **添加自定义矿工**（飞行表 → Miner → `+` → *Setup Miner Config* → **Custom**）：
   - **矿工名称（Miner name）：** `tw-pearl-miner`
   - **安装 URL（Installation URL）：**
     ```
     https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.3/tw-pearl-miner-2.0.3.tar.gz
     ```
     （也可用 `https://github.com/egg5233/tw-pearl-miner/releases/latest/download/tw-pearl-miner-2.0.3.tar.gz`）
   - **哈希算法（Hash algorithm）：** `pearl`（自由文本 —— 仅供参考）
3. 填写飞行表字段：
   | 字段 | 值 |
   |-------|-------|
   | **Wallet and worker template** | 你的 `prl1...` 收款地址（或 `prl1....%WORKER_NAME%`；带 `.worker` 后缀时该后缀作为矿机名） |
   | **Pool URL** | **必填** —— 你的矿池 `host:port`，或带传输协议前缀（见下方） |
   | **Pass** | `x` |
   | **Extra config arguments** | *（可选）* 额外的矿工 **命令行参数**，例如 `--gpus 0,1`（见下方 *额外参数*）。**不是**环境变量。 |
4. 把飞行表应用到矿机。HiveOS 会下载安装包到 `/hive/miners/custom/tw-pearl-miner/` 并开始挖矿。

![HiveOS 飞行表设置参考](hive_setting.png)

*HiveOS 飞行表设置参考 —— Custom configuration 示例：矿工名、安装 URL、钱包模板、
**Pool URL**（例如 `stratum+ssl://hk.pearl.herominers.com:1200`）、Pass=`x`、
Extra config arguments 为命令行参数（例如 `--gpus 0,1`）。*

矿机名会自动取自 rig；算力（TH/s）与接受/拒绝份额会显示在 HiveOS 面板上。

## Pool URL（必填 —— 协议前缀决定连接方式）

Pool URL 会**原样**传给矿工，URL 的协议前缀决定如何连接：

| Pool URL | 连接方式 |
|----------|----------|
| `host:port`（裸地址） | 内置**预设**矿池（herominers / kryptex / luckypool） |
| `stratum+ssl://host:port` | TLS（校验证书） |
| `stratum+tcp://host:port` | 明文 TCP |
| `stratum+ssl-insecure://host:port` | TLS 但不校验证书（例如中继 / 自签名前端，如 `stratum+ssl-insecure://<ip>:1200`） |

非预设矿池需要带明确的协议前缀。例如：`stratum+ssl://hk.pearl.herominers.com:1200`。

## 额外参数 = 命令行参数

**Extra config arguments** 里填的内容会原样追加到矿工命令行（SRBMiner 风格），多个参数用空格或换行
分隔。例如：
- `--gpus 0,1` —— 只在 0 号和 1 号显卡上挖矿
- `--no-tui` —— 关闭全屏 TUI（HiveOS 本就无头运行，写日志时会自动关闭，一般无需手动设置）

## 从 1.x 升级

- **Pool URL 现在必填。** 1.x 使用内置矿池、此字段留空。请填写你的矿池 `host:port`（非预设矿池要带
  协议前缀）。若留空，矿工不会启动，日志会提示你填写。
- **Extra config 现在是命令行参数，不是环境变量。** 旧的 `POOL_TLS=0`、`CN2=1`、`PEARL_CN2=N`、
  `POOL_HOST=`、`NO_CPU=` 这类写法已**移除**，填入后会在日志里被拒绝并给出迁移提示。传输方式改用
  Pool URL 的协议前缀（例如用 `stratum+tcp://` 代替 `POOL_TLS=0`），其它需求请用真正的 `--参数`。

## 安装包内容
```
tw-pearl-miner/
  pearl-gpu-miner       矿工二进制（fat：sm_80/86/89/90/120a + PTX）
  libpearlkernel.so     CUDA 内核
  libcudart.so.13       CUDA 运行库
  h-manifest.conf       矿工元数据（CUSTOM_VERSION=2.0.0）
  h-config.sh           从飞行表生成运行参数
  h-run.sh              启动矿工
  h-stats.sh            向 HiveOS 上报算力/份额
```

## 说明
- **显卡支持：** Ampere 或更新（需要 SM80 int8 张量核心）。不支持 Ampere 之前的显卡（GTX 10xx / RTX 20xx）。
- **驱动：** **≥ 580.65**（Linux）—— 支持 CUDA 13 的驱动。可在 HiveOS 网页端升级（矿机 → ⋮ →
  *Upgrade* / NVIDIA driver）或在 Hive Shell 里运行 `nvidia-driver-update`。如果日志出现
  `cudaGetDeviceCount returned 0` / `pk_init failed`，说明驱动**太旧** —— `nvidia-smi` 必须显示
  “CUDA Version: 13.0” 或更高。
- **卡在 570–580 驱动（上不了 CUDA 13）？** 改用 **CUDA-12.8** 版安装包 —— 速度相同，可在驱动
  ≥ 570.26 上运行（内置 `libcudart.so.12`）：
  ```
  https://github.com/egg5233/tw-pearl-miner/releases/download/v2.0.3/tw-pearl-miner-2.0.3.c12.tar.gz
  ```
- **算力单位：** 矿工的指标是 TH/s；HiveOS 按比例显示（`total khs` 字段 = `TH/s × 1e9`）。
