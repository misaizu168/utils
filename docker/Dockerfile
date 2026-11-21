FROM nvidia/cuda:13.5.0-cudnn-devel-ubuntu26.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV HOME=/home/dev
ENV PATH="/home/dev/.local/bin:$PATH"
ENV UV_CACHE_DIR=/uv-cache

RUN apt update && apt upgrade -y && apt install -y \
    unzip \
    unrar \
    git \
    curl \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    libopencv-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    vim \
    openssh-server \
    imagemagick \
    btop \
    nvtop \
    tmux \
    gh \
    zsh \
    libgl1 \
    libglib2.0-0 \
    libjpeg-dev \
    libpng-dev \
    pciutils \
    net-tools \
    iputils-ping \
    dnsutils \
    tree \
    rsync \
    ffmpeg \
    locales \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# [追加] Ubuntu 24.04 以降のイメージにある uid 1000 の既定ユーザーを消す
#        （ホストの uid 1000 と衝突して名前が "ubuntu" になるのを防ぐ）
RUN userdel -r ubuntu 2>/dev/null || true
RUN mkdir -p /home/dev /uv-cache

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN usermod -s /bin/zsh root

# [変更] /root → $HOME (/home/dev)。~ も /home/dev に展開される
RUN mkdir /home/dev/sandbox
WORKDIR /home/dev/sandbox
RUN git clone https://github.com/misaizu168/utils.git
RUN cp utils/config/ubuntu/.* $HOME 2>/dev/null || true
RUN cp utils/config/docker/.zshrc $HOME
RUN cp utils/config/docker/.bashrc $HOME

RUN curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

RUN mkdir $HOME/.config/sheldon -p

RUN cp utils/config/ubuntu/starship.toml ~/.config/
RUN cp utils/config/ubuntu/sheldon/plugins.toml ~/.config/sheldon

RUN mkdir -p ~/.config/tmux/plugins/catppuccin
RUN git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
RUN git clone https://github.com/tmux-plugins/tmux-prefix-highlight ~/.config/tmux/plugins/tmux-prefix-highlight
RUN git clone https://github.com/tmux-plugins/tmux-cpu ~/.config/tmux/plugins/tmux-cpu

# [追加] entrypoint（USER は書かない）
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/zsh"]
