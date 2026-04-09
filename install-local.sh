#!/bin/bash

python -m pip install -e ".[dev]"

python -m pip uninstall -y mlx mlx-metal
python -m pip install --no-cache-dir --force-reinstall mlx

# replace only mlx-lm with your local checkout
python -m pip install -e /Users/admin/Code/Waldwicht/waldwicht/mlx-lm --no-deps

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