#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_record_grid info
PYTHONPATH=src python -m gbt_record_grid check --payload '{"text": "<在此填写>", "path": "./example.txt"}'
PYTHONPATH=src python -m gbt_record_grid run   --payload '{"text": "<在此填写>", "path": "./example.txt"}'
