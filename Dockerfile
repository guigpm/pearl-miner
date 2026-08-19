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

COPY --chown=miners:miners .docker/downloads /miners/downloads
COPY --chown=miners:miners .docker/run /miners/run

RUN chmod +x /miners/downloads/*.sh \
  && chmod +x /miners/run/*.sh


# # --------------------------------------------------------
# # 1. INSTALAÇÃO DO SRBMINER-MULTI
# # --------------------------------------------------------
# #  https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/SRBMiner-Multi-${VERSION_DASH}-Linux.tar.gz
# #  https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/srbminer_custom-${VERSION_TAG}.tar.gz
# RUN . /miners/downloads/srbminer.sh \
#   && download_srbminer_custom "3.3.3" \
#   && download_srbminer_custom "3.3.4" \
#   && download_srbminer_custom "3.3.5" \
#   && download_srbminer_custom "3.3.6" \
#   && download_srbminer_custom "3.3.7" \
#   && download_srbminer_custom "3.3.8" \
#   && download_srbminer_custom "3.3.9" \
#   && download_srbminer_custom "3.4.0" \
#   && download_srbminer_custom "3.4.1" \
#   && download_srbminer_custom "3.4.2" \
#   && download_srbminer_custom "3.4.7" \
#   && download_srbminer_custom "3.4.9" \
#   && download_srbminer_custom "3.5.0" \
#   && download_srbminer_custom "3.5.4"

#   RUN . /miners/downloads/srbminer.sh \
#   && download_srbminer "3.5.0" \
#   && download_srbminer "3.5.4"

# # --------------------------------------------------------
# # 2. INSTALAÇÃO DO ALPHA-MINER (Pearl Network)
# # --------------------------------------------------------

# RUN . /miners/downloads/alpha-miner.sh \
#   && download_alphaminer "1.7.7" \
#   && download_alphaminer "1.7.6-beta" \
#   && download_alphaminer "1.8.2" \
#   && download_alphaminer "1.8.6" \
#   && download_alphaminer "1.8.8"

# RUN curl -L -o alpha-miner-latest https://pearl.alphapool.tech/downloads/alpha-miner && \
#   chown -R miners:miners ./alpha-miner-latest && \
#   chmod +x alpha-miner-latest

# # --------------------------------------------------------
# # 3. INSTALAÇÃO DO CRYPTIX-MINER (Cryptix Network)
# # --------------------------------------------------------

# RUN . /miners/downloads/cryptix-miner.sh \
#   && download_cryptix_miner "0.2.9" \
#   && download_cryptix_miner "0.2.10" "ubuntu64"

# # --------------------------------------------------------
# # 4. INSTALAÇÃO DO FL4SHMINER
# # --------------------------------------------------------

# RUN . /miners/downloads/fl4shminer.sh \
#   && download_fl4shminer "v1.2.0" \
#   && download_fl4shminer "v1.2.3" \
#   && download_fl4shminer "v1.2.4" \
#   && download_fl4shminer "v1.3.0"

# # --------------------------------------------------------
# # 5. INSTALAÇÃO DO GMINER
# # --------------------------------------------------------

#  # https://github.com/develsoftware/GMinerRelease/releases/download/3.44/gminer_3_44_linux64.tar.xz
# RUN . /miners/downloads/gminer.sh \
#   && download_gminer "3.43" \
#   && download_gminer "3.44"

# --------------------------------------------------------
# CONFIGURAÇÃO DE INICIALIZAÇÃO FLEXÍVEL
# --------------------------------------------------------
# Sem ENTRYPOINT engessado. O padrão inicializa o Bash.

#RUN ls -lahR /miners

EXPOSE 80

# Switch to non-root user for security
USER miners

CMD ["/bin/bash"]

