#!/usr/bin/env bash
# Build command for Cloudflare Workers (static assets). Installs Typst (the
# Cloudflare build environment doesn't have it preinstalled), builds the
# interactive HTML (which also rebuilds the PDF it embeds), then arranges the
# output into dist/index.html the way wrangler.toml's [assets] directory =
# "dist" expects. Math is native-Typst -> MathML, so no extra fonts or JS are
# fetched at build time.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

TYPST_VERSION="0.15.1"
if ! command -v typst >/dev/null 2>&1; then
  curl -fsSL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" -o /tmp/typst.tar.xz
  tar -xf /tmp/typst.tar.xz -C /tmp
  mkdir -p "$HOME/.local/bin"
  mv "/tmp/typst-x86_64-unknown-linux-musl/typst" "$HOME/.local/bin/typst"
  export PATH="$HOME/.local/bin:$PATH"
fi
typst --version

python3 web/build.py

mkdir -p dist
cp DWT_Lernskript.html dist/index.html
echo "Wrote dist/index.html"
