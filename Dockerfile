# Imagem base do NVIDIA CUDA (baseada em Ubuntu) para garantir suporte a GPU
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
#FROM ubuntu:24.04

USER root

# Evita perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências comuns (CURL, GIT, dependências de vídeo e extração)
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get install -y \
    expect \
    curl \
    wget \
    git \
    ca-certificates \
    xz-utils \
    libnuma1 \
    libnuma-dev \
    libstdc++6 \
    kmod \
    opencl-c-headers \
  && update-ca-certificates \
  && apt-get -y autoremove --purge \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /miners \
  && groupadd -r miners && useradd -r -g miners -d /miners -s /bin/bash miners \
  && chown -R miners:miners /miners

# Diretório onde os mineradores ficarão centralizados
WORKDIR /miners


# --------------------------------------------------------
# 1. INSTALAÇÃO DO SRBMINER-MULTI
# --------------------------------------------------------
RUN download_srbminer() { \
    set -e; \
    local VERSION_TAG="$1"; \
    wget -qO- "https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/srbminer_custom-${VERSION_TAG}.tar.gz" | tar -xzvf - -C /miners; \
    chown -R miners:miners ./srbminer_custom; \
    chmod +x ./srbminer_custom/srbminer_custom_bin; \
    mv ./srbminer_custom "./srbminer_${VERSION_TAG}"; \
  } \
  && download_srbminer "3.3.3" \
  && download_srbminer "3.3.4" \
  && download_srbminer "3.3.5"

# --------------------------------------------------------
# 2. INSTALAÇÃO DO ALPHA-MINER (Pearl Network)
# --------------------------------------------------------
# O alpha-miner disponibiliza o executável direto nas releases do GitHub
RUN curl -L -o alpha-miner-1.7.7 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.7/alpha-miner-1.7.7 && \
  echo "2cddd2956e11faf4e564d4a901adc13b51137e32bad181eb1c75c8b83eaf27ba  alpha-miner-1.7.7" | sha256sum -c && \
  chown -R miners:miners ./alpha-miner-1.7.7 && \
  chmod +x alpha-miner-1.7.7

RUN curl -L -o alpha-miner-1.7.6-beta https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.6-beta/alpha-miner && \
  echo "c84396e2ff4ded14a8c83cd253761b46dd40927c5c43a39a20aac9ff8bdfbfe5  alpha-miner-1.7.6-beta" | sha256sum -c && \
  chown -R miners:miners ./alpha-miner-1.7.6-beta && \
  chmod +x alpha-miner-1.7.6-beta

# --------------------------------------------------------
# CONFIGURAÇÃO DE INICIALIZAÇÃO FLEXÍVEL
# --------------------------------------------------------
# Sem ENTRYPOINT engessado. O padrão inicializa o Bash.

EXPOSE 80

# Switch to non-root user for security
USER miners

CMD ["/bin/bash"]

