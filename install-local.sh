#!/bin/bash
# Install omlx for local Waldwicht development.
# Expects to be run from the omlx/ directory (or the repo root's Makefile).
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

python -m pip install -e ".[dev]"

# Only reinstall mlx from pip if the local fork isn't already installed
if python -c "import mlx; print(mlx.__file__)" 2>/dev/null | grep -q "$REPO_ROOT/mlx"; then
    echo "=> Local mlx fork already installed, skipping."
else
    python -m pip uninstall -y mlx mlx-metal 2>/dev/null || true
    python -m pip install --no-cache-dir --force-reinstall mlx
fi

# Replace only mlx-lm with the local checkout
python -m pip install -e "$REPO_ROOT/mlx-lm" --no-deps

python - <<'PY'
import mlx.core as mx
print(mx.__file__)
PY

python - <<'PY'
import importlib.util
print(importlib.util.find_spec("mlx_lm"))
PY


python -m pip show mlx
python -m pip show mlx-lm