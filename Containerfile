FROM alpine:latest

# 1. Install system packages cleanly
RUN apk add --no-cache neovim git ripgrep build-base

# 2. Create unprivileged user upfront
RUN adduser -D -u 1000 nvim-user

# 3. Create config and state directories with correct ownership
RUN mkdir -p /home/nvim-user/.config/nvim /home/nvim-user/.local /home/nvim-user/.cache \
    && chown -R nvim-user:nvim-user /home/nvim-user

# 4. Switch to unprivileged user BEFORE building the config
USER nvim-user
WORKDIR /home/nvim-user

# 5. Copy configuration into the user's home directory
COPY --chown=nvim-user:nvim-user ./nvim /home/nvim-user/.config/nvim

# 6. Pre-install/headless sync plugins into the user's home path
RUN nvim --headless "+Lazy! sync" +qa

RUN alias vim=nvim

WORKDIR /nvim-workspace
