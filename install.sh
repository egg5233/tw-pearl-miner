#!/usr/bin/env bash
# tw-pearl-miner Linux installer — downloads + extracts the latest bundle.
#   curl -fsSL https://github.com/egg5233/tw-pearl-miner/raw/main/install.sh | bash
# or: ./install.sh [install-dir]   (default: ~/tw-pearl-miner)
set -euo pipefail

URL="https://github.com/egg5233/tw-pearl-miner/releases/download/v1.8.0/tw-pearl-miner-linux.tar.gz"
DEST="${1:-$HOME/tw-pearl-miner}"

command -v curl >/dev/null || { echo "need 'curl'"; exit 1; }
echo "Installing tw-pearl-miner -> $DEST"
mkdir -p "$DEST"
curl -fsSL "$URL" | tar xz -C "$DEST" --strip-components=1
chmod +x "$DEST/pearl-gpu-miner" "$DEST/start.sh"

echo
echo "Installed. Next:"
echo "  1) edit $DEST/start.sh and set WALLET to your prl1... address"
echo "  2) cd $DEST && ./start.sh"
echo
echo "Requires an Ampere-or-newer NVIDIA GPU and a CUDA-13 driver (>=580)."
