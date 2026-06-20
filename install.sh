#!/usr/bin/env bash
#
# Non-Homebrew installer: copies adbqr to a bin dir on your PATH.
# Usage:  ./install.sh [PREFIX]   (default PREFIX=/usr/local)
#
# Prefer Homebrew if you have it:  brew install kristjan/tap/adbqr

set -euo pipefail

PREFIX="${1:-/usr/local}"
SRC="$(cd "$(dirname "$0")" && pwd)/bin/adbqr"
DEST="$PREFIX/bin/adbqr"

[ -f "$SRC" ] || { echo "Error: $SRC not found." >&2; exit 1; }

echo "Installing adbqr to $DEST"
if [ -w "$PREFIX/bin" ]; then
    install -m 0755 "$SRC" "$DEST"
else
    sudo install -m 0755 "$SRC" "$DEST"
fi

echo "Done. Make sure '$PREFIX/bin' is on your PATH, then run: adbqr"
echo "Note: adbqr needs 'adb' and 'qrencode' installed separately."
