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
    p7zip-full \
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
    echo ">> Download SRBMiner-Multi ${VERSION_TAG} and extract files:"; \
    wget -qO- "https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/srbminer_custom-${VERSION_TAG}.tar.gz" | tar -xzvf - -C /miners; \
    chown -R miners:miners ./srbminer_custom; \
    chmod +x ./srbminer_custom/srbminer_custom_bin; \
    mv ./srbminer_custom "./srbminer_${VERSION_TAG}"; \
  } \
  && download_srbminer "3.3.3" \
  && download_srbminer "3.3.4" \
  && download_srbminer "3.3.5" \
  && download_srbminer "3.3.6" \
  && download_srbminer "3.3.7" \
  && download_srbminer "3.3.8" \
  && download_srbminer "3.3.9" \
  && download_srbminer "3.4.0" \
  && download_srbminer "3.4.1" \
  && download_srbminer "3.4.2" \
  && download_srbminer "3.4.7" \
  && download_srbminer "3.4.9" \
  && download_srbminer "3.5.0"

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

RUN curl -L -o alpha-miner-1.8.2 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.8.2/alpha-miner-1.8.2 && \
  echo "9daff37e9669263a6f474e5604ee91ba5391e4bb20e4594666ff310de0ccca6e  alpha-miner-1.8.2" | sha256sum -c && \
  chown -R miners:miners ./alpha-miner-1.8.2 && \
  chmod +x alpha-miner-1.8.2

RUN curl -L -o alpha-miner-1.8.6 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.8.6/alpha-miner && \
  echo "4d200e1d710f8095d5d5aa1e944689b1972dbc84a61190a07efeaa327339e126  alpha-miner-1.8.6" | sha256sum -c && \
  chown -R miners:miners ./alpha-miner-1.8.6 && \
  chmod +x alpha-miner-1.8.6

RUN curl -L -o alpha-miner-1.8.8 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.8.8/alpha-miner && \
  echo "96502aaf7ca8a94121632364987cfc4cb03c007303acf803abda8957e5a80f36  alpha-miner-1.8.8" | sha256sum -c && \
  chown -R miners:miners ./alpha-miner-1.8.8 && \
  chmod +x alpha-miner-1.8.8

RUN curl -L -o alpha-miner-latest https://pearl.alphapool.tech/downloads/alpha-miner && \
  chown -R miners:miners ./alpha-miner-latest && \
  chmod +x alpha-miner-latest

# --------------------------------------------------------
# 3. INSTALAÇÃO DO CRYPTIX-MINER (Cryptix Network)
# --------------------------------------------------------

RUN download_cryptix_miner() { \
    set -e; \
    local VERSION_TAG="$1"; \
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')"; \
    local OS_TYPE="${2:-linux64}"; \
    local FOLDER_NAME="cryptix-miner-${OS_TYPE}-v-${VERSION_DASH}"; \
    echo ">> Download cryptix-miner and extract files:"; \
    curl -L -o /tmp/cryptix-miner.7z "https://github.com/cryptix-network/cryptix-miner/releases/download/v${VERSION_TAG}/${FOLDER_NAME}.7z"; \
    7z x /tmp/cryptix-miner.7z -o"."; \
    chown -R miners:miners "./${FOLDER_NAME}"; \
    chmod +x "./${FOLDER_NAME}/cryptix-miner"; \
    mv "./${FOLDER_NAME}" "./cryptix_miner_${VERSION_TAG}"; \
  } \
  && download_cryptix_miner "0.2.9" \
  && download_cryptix_miner "0.2.10" "ubuntu64"


# --------------------------------------------------------
# CONFIGURAÇÃO DE INICIALIZAÇÃO FLEXÍVEL
# --------------------------------------------------------
# Sem ENTRYPOINT engessado. O padrão inicializa o Bash.

RUN ls -lahR /miners

EXPOSE 80

# Switch to non-root user for security
USER miners

CMD ["/bin/bash"]

