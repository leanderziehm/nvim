# nvim

todo is there any way to have defaults there not broken links

```
podman run --rm -it \
  --network none \
  --read-only \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  --userns=keep-id \
  --tmpfs /tmp:rw,noexec,nosuid \
  # Mount ONLY the single override file as read-only:
  -v ~/.config/my-nvim-overrides/overrides.lua:/home/editor/.config/nvim/overrides.lua:ro \
  # Workspace bind mount:
  -v /path/to/my-project:/workspace:rw \
  my-registry.com/my-hardened-nvim:latest nvim .
```