FROM alpine:latest

# 1. Install system packages cleanly
RUN apk add --no-cache neovim git ripgrep build-base

# 2. Create unprivileged user upfront
RUN adduser -D -u 1000 nvim-user

# 3. Create config and state directories with correct ownership
RUN mkdir -p /home/nvim-user/.config/nvim \
             /home/nvim-user/.local/share/nvim \
             /home/nvim-user/.local/state/nvim \
             /home/nvim-user/.cache/nvim \
    && chown -R nvim-user:nvim-user /home/nvim-user

# 4. Switch to unprivileged user and set HOME explicitly
USER nvim-user
ENV HOME=/home/nvim-user
ENV PATH="/usr/bin:${PATH}"
WORKDIR /home/nvim-user

# 5. Copy configuration into the user's home directory
COPY --chown=nvim-user:nvim-user ./nvim /home/nvim-user/.config/nvim

# 6. Synchronize plugins synchronously and wait until completely finished
RUN nvim --headless "+Lazy! install" "+Lazy! sync" +qa

# 7. Create a permanent system symlink for 'vim' -> 'nvim' (run as root)
USER root
RUN ln -s /usr/bin/nvim /usr/bin/vim

# 8. Switch back to unprivileged user for workspace entrypoint
USER nvim-user
WORKDIR /nvim-workspace