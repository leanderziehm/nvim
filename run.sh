#!/usr/bin/env bash
set -e

TAG="${1:-latest}"
IMAGE="ghcr.io/leanderziehm/nvim:${TAG}"

mkdir -p ~/nvim-workspace ~/.config/nvim-overrides
touch ~/.config/nvim-overrides/overrides.lua

podman run --rm -it \
  --pull always \
  --network none \
  --read-only \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  --userns=keep-id \
  --tmpfs /tmp:rw,noexec,nosuid \
  -v ~/.config/nvim-overrides/overrides.lua:/home/nvim-user/.config/nvim/overrides.lua:ro \
  -v nvim-state-vol:/home/nvim-user/.local/state/nvim:rw \
  -v nvim-state-vol:/home/nvim-user/.local/share/nvim:rw \
  -v ~/nvim-workspace:/nvim-workspace:rw \
  "$IMAGE"