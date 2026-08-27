# nvim

## Run
```
mkdir -p ~/my-nvim ~/.config/my-nvim-overrides && touch ~/.config/my-nvim-overrides/overrides.lua

podman run --rm -it \
  --network none \
  --read-only \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  --userns=keep-id \
  --tmpfs /tmp:rw,noexec,nosuid \
  -v ~/.config/my-nvim-overrides/overrides.lua:/home/editor/.config/nvim/overrides.lua:ro \
  -v ~/my-nvim:/workspace:rw \
  ghcr.io/leanderziehm/nvim:latest
```