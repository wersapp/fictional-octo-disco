FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update + paket umum
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    openssh-server \
    sudo \
    nano \
    vim \
    curl \
    wget \
    git \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    openjdk-17-jdk \
    htop \
    neofetch \
    tree \
    jq \
    rsync \
    net-tools \
    iproute2 \
    iputils-ping \
    dnsutils \
    netcat-openbsd \
    telnet \
    traceroute \
    procps \
    psmisc \
    lsof \
    file \
    less \
    man-db \
    locales \
    tzdata \
    screen \
    tmux \
    cron \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Locale
RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Root password
RUN echo 'root:root' | chpasswd

# SSH configuration
RUN mkdir -p /run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Jangan gunakan privilege drop
RUN echo "root ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/root && \
    chmod 440 /etc/sudoers.d/root

# Working directory
WORKDIR /root

# Startup script
RUN printf '#!/bin/bash\n\
set -e\n\
mkdir -p /run/sshd\n\
echo "========================================"\n\
echo " Ubuntu Railway Container"\n\
echo " User     : root"\n\
echo " Password : root"\n\
echo "========================================"\n\
echo ""\n\
echo "Container IP:"\n\
hostname -I || true\n\
echo ""\n\
exec /usr/sbin/sshd -D -e\n' > /start.sh && \
    chmod +x /start.sh

# Railway menyediakan PORT secara dinamis.
# SSH akan menggunakan port 22 di dalam container.
EXPOSE 22

CMD ["/start.sh"]
