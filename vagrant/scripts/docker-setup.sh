#!/usr/bin/env bash
set -euo pipefail


curl -fsSL https://get.docker.com -o get-docker.sh \
&& sh ./get-docker.sh \
&& usermod -aG docker vagrant