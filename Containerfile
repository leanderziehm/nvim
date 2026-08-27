FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------
# 1. Install system dependencies
# --------------------------------------------------
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        ripgrep \
        build-essential \
        xz-utils \
        tar \
        unzip \
    && rm -rf /var/lib/apt/lists/*


# --------------------------------------------------
# 2. Install modern Neovim from the official release
# --------------------------------------------------
ARG TARGETARCH

RUN case "${TARGETARCH}" in \
        amd64) NVIM_ARCH="x86_64" ;; \
        arm64) NVIM_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fL \
        "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.tar.gz" \
        -o /tmp/nvim.tar.gz \
    && mkdir -p /opt/nvim \
    && tar -xzf /tmp/nvim.tar.gz \
        -C /opt/nvim \
        --strip-components=1 \
    && rm /tmp/nvim.tar.gz \
    && ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && ln -sf /opt/nvim/bin/nvim /usr/local/bin/vim \
    && nvim --version


# --------------------------------------------------
# 3. Create the unprivileged user
# --------------------------------------------------
RUN useradd \
        --create-home \
        --uid 1000 \
        --shell /bin/bash \
        nvim-user


# --------------------------------------------------
# 4. Create all Neovim and workspace directories
# --------------------------------------------------
RUN mkdir -p \
        /home/nvim-user/.config/nvim \
        /home/nvim-user/.local/share/nvim \
        /home/nvim-user/.local/state/nvim \
        /home/nvim-user/.cache/nvim \
        /nvim-workspace \
    && chown -R nvim-user:nvim-user \
        /home/nvim-user \
        /nvim-workspace


# --------------------------------------------------
# 5. Switch to the non-root user
# --------------------------------------------------
USER nvim-user

ENV HOME=/home/nvim-user
ENV PATH="/usr/local/bin:${PATH}"

WORKDIR /home/nvim-user


# --------------------------------------------------
# 6. Copy your Neovim configuration
# --------------------------------------------------
COPY --chown=nvim-user:nvim-user ./nvim \
    /home/nvim-user/.config/nvim


# --------------------------------------------------
# 7. Install lazy.nvim
# --------------------------------------------------
RUN git clone \
        --filter=blob:none \
        --branch=stable \
        https://github.com/folke/lazy.nvim.git \
        /home/nvim-user/.local/share/nvim/lazy/lazy.nvim


# --------------------------------------------------
# 8. Restore plugins from lazy-lock.json
#
# Hard timeout prevents GitHub Actions from hanging
# forever if a plugin or build hook gets stuck.
# --------------------------------------------------
RUN timeout 30m \
        nvim --headless \
        -c "autocmd User LazyDone quitall" \
        -c "Lazy! restore" \
    || exit 1


# --------------------------------------------------
# 9. Final workspace
# --------------------------------------------------
WORKDIR /nvim-workspace