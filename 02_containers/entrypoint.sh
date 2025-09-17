#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Received SIGTERM"; exit 0' TERM INT
while true; do echo "running"; sleep 2; done